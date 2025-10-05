import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/search_history_entry.dart';
import '../models/search_result.dart';

// === HTTP CLIENT CONFIGURATION ===
// Konfigurasi HTTP client yang berbeda untuk setiap platform
class ApiHttpClient {
  static http.Client getClient() {
    if (kIsWeb) {
      // Flutter Web - gunakan client dengan konfigurasi khusus
      return _WebHttpClient();
    }
    // Mobile/Desktop - gunakan client default dengan timeout
    return http.Client();
  }
}

// === WEB-SPECIFIC HTTP CLIENT ===
class _WebHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    // Tambahkan headers tambahan untuk web
    request.headers['Access-Control-Allow-Origin'] = '*';
    request.headers['Access-Control-Allow-Methods'] = 'GET, POST, DELETE, OPTIONS';
    request.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization';

    return _inner.send(request);
  }
}

/// Kelas helper untuk berkomunikasi dengan backend Laravel.
/// Dilengkapi dengan error handling dan timeout untuk status code 0.
class SearchApi {
  const SearchApi();

  // === TIMEOUT CONFIGURATION ===
  static const Duration _requestTimeout = Duration(seconds: 15);
  static const int _maxRetries = 2;

  // === SECURE STORAGE ===
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Get authentication token from secure storage
  Future<String?> _getAuthToken() async {
    return await _storage.read(key: 'auth_token');
  }

  /// Get common headers including authentication
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getAuthToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Access-Control-Allow-Origin': '*',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  /// Mengirim permintaan pencarian ke backend dan mengubah hasil
  /// JSON menjadi daftar `SearchResult`.
  /// Dilengkapi dengan retry logic dan timeout handling.
  Future<List<SearchResult>> search(String query, {int limit = 20}) async {
    Exception? lastException;

    // Retry logic untuk handle temporary failures
    for (int attempt = 0; attempt <= _maxRetries; attempt++) {
      try {
        final result = await _executeSearch(query, limit);
        return result;
      } catch (e) {
        lastException = e as Exception;

        // Jika ini adalah status code 0 atau network error, retry
        if (attempt < _maxRetries && _isRetryableError(e)) {
          await Future.delayed(Duration(seconds: attempt + 1)); // Exponential backoff
          continue;
        }
        break;
      }
    }

    // Throw last exception jika semua retry gagal
    throw lastException ?? Exception('Unknown error occurred');
  }

  Future<List<SearchResult>> _executeSearch(String query, int limit) async {
    final uri = Uri.parse('$apiBaseUrl$searchEndpoint');
    final client = ApiHttpClient.getClient();
    final headers = await _getHeaders();

    try {
      final response = await client
          .post(
            uri,
            headers: headers,
            body: jsonEncode({'query': query, 'limit': limit}),
          )
          .timeout(_requestTimeout);

      return await _handleResponse<List<SearchResult>>(
        response,
        (body) {
          final results = body['results'] as List<dynamic>? ?? [];
          return results
              .map((dynamic item) =>
                  SearchResult.fromJson(item as Map<String, dynamic>))
              .toList();
        },
        'Terjadi kesalahan saat mengambil data pencarian.',
      );
    } finally {
      client.close();
    }
  }

  /// Mengambil daftar riwayat pencarian dengan error handling yang lebih baik.
  Future<List<SearchHistoryEntry>> fetchHistory({int perPage = 50}) async {
    final uri = Uri.parse(
      '$apiBaseUrl$historyEndpoint?per_page=${perPage.clamp(1, 100)}',
    );
    final client = ApiHttpClient.getClient();
    final headers = await _getHeaders();

    try {
      final response = await client
          .get(
            uri,
            headers: headers,
          )
          .timeout(_requestTimeout);

      return await _handleResponse<List<SearchHistoryEntry>>(
        response,
        (body) {
          final data = body['data'] as List<dynamic>? ?? [];
          return data
              .map((dynamic item) =>
                  SearchHistoryEntry.fromJson(item as Map<String, dynamic>))
              .toList();
        },
        'Terjadi kesalahan saat memuat riwayat.',
      );
    } finally {
      client.close();
    }
  }

  /// Menghapus seluruh riwayat pencarian dengan error handling.
  Future<void> clearHistory() async {
    final uri = Uri.parse('$apiBaseUrl$historyEndpoint');
    final client = ApiHttpClient.getClient();
    final headers = await _getHeaders();

    try {
      final response = await client
          .delete(
            uri,
            headers: headers,
          )
          .timeout(_requestTimeout);

      await _handleResponse<void>(
        response,
        (_) {}, // No-op for successful deletion
        'Terjadi kesalahan saat menghapus riwayat.',
      );
    } finally {
      client.close();
    }
  }

  /// Helper method untuk handle HTTP response dengan error handling yang komprehensif
  Future<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic> body) onSuccess,
    String fallbackMessage,
  ) async {
    // Handle status code 0 dan network errors
    if (response.statusCode == 0) {
      throw Exception('Network error: Tidak dapat terhubung ke server. Periksa koneksi internet atau konfigurasi CORS.');
    }

    // Handle timeout dan connection errors
    if (response.statusCode >= 500) {
      throw Exception('Server error: ${response.statusCode}. Silakan coba lagi nanti.');
    }

    if (response.statusCode >= 400 && response.statusCode < 500) {
      if (response.statusCode == 401) {
        // Clear invalid token
        await _storage.delete(key: 'auth_token');
        throw Exception('Sesi login telah berakhir. Silakan login kembali.');
      }
      throw Exception('Client error: ${response.statusCode}. Periksa permintaan atau kredensial.');
    }

    if (response.statusCode != 200) {
      try {
        final Map<String, dynamic>? body =
            jsonDecode(response.body) as Map<String, dynamic>?;
        final message = body?['message'] as String? ?? fallbackMessage;
        throw Exception(message);
      } catch (e) {
        throw Exception('$fallbackMessage (Status: ${response.statusCode})');
      }
    }

    // Parse successful response
    try {
      final Map<String, dynamic> body =
          jsonDecode(response.body) as Map<String, dynamic>;
      return onSuccess(body);
    } catch (e) {
      throw Exception('Error parsing response: ${e.toString()}');
    }
  }

  /// Menentukan apakah error dapat di-retry
  bool _isRetryableError(Exception error) {
    final message = error.toString().toLowerCase();
    return message.contains('network') ||
           message.contains('timeout') ||
           message.contains('connection') ||
           message.contains('cors') ||
           message.contains('status code: 0');
  }
}
