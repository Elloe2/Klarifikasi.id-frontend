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
/// - Production: Domain production dari environment variables
///
/// Usage:
/// ```dart
/// final response = await http.get(Uri.parse('${apiBaseUrl}/api/search'));
/// ```
String get apiBaseUrl {
  // === PRODUCTION ENVIRONMENT (Netlify) ===
  // Gunakan environment variables yang di-set di Netlify
  const String productionUrl = String.fromEnvironment('API_BASE_URL');

  if (productionUrl.isNotEmpty && productionUrl != 'http://localhost') {
    return productionUrl;
  }

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

  // === FALLBACK PRODUCTION ===
  // TODO: Update dengan URL Render production setelah deployment berhasil
  // Contoh: return 'https://klarifikasi-backend.onrender.com';
  return 'https://your-render-app.onrender.com'; // Ganti dengan URL Render asli setelah deploy
}

/// === GOOGLE CSE API CONFIGURATION ===
/// Getter function untuk Google Custom Search Engine API Key.
/// Digunakan untuk search functionality dengan Google CSE.
///
/// Returns:
/// - Production: API key dari environment variables (Netlify)
/// - Development: API key dari environment variables atau default
String get googleCseApiKey {
  // === PRODUCTION ENVIRONMENT (Netlify) ===
  const String productionKey = String.fromEnvironment('GOOGLE_CSE_API_KEY');

  if (productionKey.isNotEmpty && productionKey != 'your-api-key') {
    return productionKey;
  }

  // === FALLBACK ===
  // TODO: Update dengan API key production setelah deployment berhasil
  return 'AIzaSyAFOdoaMwgurnjfnhGKn5GFy6_m2HKiGtA'; // Ganti dengan API key production
}

/// === GOOGLE CSE CX CONFIGURATION ===
/// Getter function untuk Google Custom Search Engine Context (CX).
/// Digunakan untuk mengidentifikasi search engine yang digunakan.
///
/// Returns:
/// - Production: CX dari environment variables (Netlify)
/// - Development: CX dari environment variables atau default
String get googleCseCx {
  // === PRODUCTION ENVIRONMENT (Netlify) ===
  const String productionCx = String.fromEnvironment('GOOGLE_CSE_CX');

  if (productionCx.isNotEmpty && productionCx != 'your-cx-id') {
    return productionCx;
  }

  // === FALLBACK ===
  // TODO: Update dengan CX production setelah deployment berhasil
  return '6242f5825dedb4b59'; // Ganti dengan CX production
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
