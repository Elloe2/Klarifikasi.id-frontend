/// ============================================================================
/// KONFIGURASI API & ENDPOINTS - KLARIFIKASI.ID FRONTEND
/// ============================================================================
/// File ini berisi konfigurasi untuk koneksi API antara Flutter frontend
/// dengan Laravel backend. Mengatur base URL dan endpoint paths.
///
/// Struktur:
/// - apiBaseUrl: Base URL untuk API calls (adaptive untuk dev/prod)
/// - searchEndpoint: Endpoint untuk pencarian fact-checking
/// - historyEndpoint: Endpoint untuk riwayat pencarian
/// ============================================================================
library;

import 'package:flutter/foundation.dart'; // Untuk detection platform (Web/Mobile)

/// === BASE URL CONFIGURATION ===
/// Getter function yang mengembalikan base URL untuk API calls.
/// Otomatis mendeteksi environment (development/production) dan platform.
///
/// Returns:
/// - Development: localhost:8000 untuk Web, 10.0.2.2:8000 untuk Android emulator
/// - Production: Domain production yang dikonfigurasi
///
/// Usage:
/// ```dart
/// final response = await http.get(Uri.parse('${apiBaseUrl}/api/search'));
/// ```
String get apiBaseUrl {
  // === DEVELOPMENT ENVIRONMENT ===
  if (kDebugMode) {
    // Platform detection untuk konfigurasi yang tepat
    if (kIsWeb) {
      // Flutter Web development - connect ke Laravel backend lokal
      // Menggunakan localhost:8000 untuk komunikasi dengan Laravel server
      return 'http://localhost:8000';
    } else {
      // Android emulator atau physical device
      // Android emulator menggunakan 10.0.2.2 untuk mengakses localhost host machine
      return 'http://10.0.2.2:8000';
    }
  }

  // === PRODUCTION ENVIRONMENT ===
  // TODO: Update dengan URL Render production setelah deployment berhasil
  // Contoh: return 'https://klarifikasi-backend.onrender.com';
  return 'https://your-render-app.onrender.com'; // Ganti dengan URL Render asli setelah deploy
}

/// === SEARCH ENDPOINT CONFIGURATION ===
/// Endpoint untuk melakukan pencarian fact-checking.
/// Mengirim query ke Google Custom Search Engine melalui Laravel backend.
///
/// Path: /api/search
/// Method: POST
/// Body: {'query': 'search term', 'limit': 20}
///
/// Usage:
/// ```dart
/// final response = await http.post(
///   Uri.parse('$apiBaseUrl$searchEndpoint'),
///   headers: {'Content-Type': 'application/json'},
///   body: jsonEncode({'query': query, 'limit': 20}),
/// );
/// ```
const String searchEndpoint = '/api/search';

/// === HISTORY ENDPOINT CONFIGURATION ===
/// Endpoint untuk mengambil riwayat pencarian pengguna.
/// Menampilkan daftar pencarian sebelumnya dengan pagination.
///
/// Path: /api/history
/// Method: GET
/// Query Parameters: ?per_page=20
/// Authentication: Required (Bearer token)
///
/// Usage:
/// ```dart
/// final response = await http.get(
///   Uri.parse('$apiBaseUrl$historyEndpoint?per_page=50'),
///   headers: {'Authorization': 'Bearer $token'},
/// );
/// ```
const String historyEndpoint = '/api/history';

/// === ADDITIONAL ENDPOINTS ===
/// Berikut adalah endpoint lainnya yang digunakan dalam aplikasi:
///
/// Authentication Endpoints:
/// - POST /api/auth/register - User registration
/// - POST /api/auth/login - User login
/// - GET /api/auth/profile - Get user profile (auth required)
/// - POST /api/auth/profile - Update user profile (auth required)
/// - POST /api/auth/logout - User logout (auth required)
///
/// Search Endpoints:
/// - POST /api/search - Perform fact-checking search (auth required)
/// - GET /api/history - Get search history (auth required)
/// - DELETE /api/history - Clear search history (auth required)
///
/// === SECURITY CONSIDERATIONS ===
/// - Semua authenticated endpoints memerlukan Bearer token
/// - Token disimpan securely menggunakan Flutter Secure Storage
/// - Rate limiting diterapkan di backend (10 requests/minute untuk search)
/// - CORS dikonfigurasi untuk mengizinkan requests dari Flutter app
///
/// === ERROR HANDLING ===
/// - Timeout: 10 detik untuk semua API calls
/// - Retry logic untuk network failures
/// - Proper error messages untuk user feedback
