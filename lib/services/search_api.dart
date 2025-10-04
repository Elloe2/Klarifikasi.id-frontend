import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/search_history_entry.dart';
import '../models/search_result.dart';

class SearchApi {
  const SearchApi();

  Future<List<SearchResult>> search(String query) async {
    final uri = Uri.parse('$apiBaseUrl$searchEndpoint');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'query': query}),
    );

    if (response.statusCode != 200) {
      final Map<String, dynamic>? body =
          jsonDecode(response.body) as Map<String, dynamic>?;
      final message = body?['message'] as String? ??
          'Terjadi kesalahan saat mengambil data.';
      throw Exception(message);
    }

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;
    final results = body['results'] as List<dynamic>? ?? [];

    return results
        .map((dynamic item) =>
            SearchResult.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<SearchHistoryEntry>> fetchHistory({int perPage = 50}) async {
    final uri = Uri.parse(
      '$apiBaseUrl$historyEndpoint?per_page=${perPage.clamp(1, 100)}',
    );

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      final Map<String, dynamic>? body =
          jsonDecode(response.body) as Map<String, dynamic>?;
      final message = body?['message'] as String? ??
          'Terjadi kesalahan saat memuat riwayat.';
      throw Exception(message);
    }

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>? ?? [];

    return data
        .map((dynamic item) =>
            SearchHistoryEntry.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
