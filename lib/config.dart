/// ============================================================================
/// KONFIGURASI API & ENDPOINTS - KLARIFIKASI.ID FRONTEND
/// ============================================================================
/// File ini berisi konfigurasi untuk koneksi API antara Flutter frontend
/// dengan Laravel backend. Mengatur base URL dan endpoint paths.
///
/// Struktur:
/// - apiBaseUrl: Base URL untuk API calls (adaptive untuk dev/prod)
/// - searchEndpoint: Endpoint untuk pencarian fact-checking
/// ============================================================================
library;

// Import tidak diperlukan karena menggunakan Laravel Cloud untuk semua environment

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
  // === LARAVEL CLOUD BACKEND ===
  // Gunakan Laravel Cloud untuk semua environment
  // Semua request frontend diarahkan ke instance Laravel Cloud produksi
  return 'https://klarifikasiid-backend-main-ki47jp.laravel.cloud';
}

/// === GOOGLE CSE API CONFIGURATION ===
/// Getter function untuk Google Custom Search Engine API Key.
/// Digunakan untuk search functionality dengan Google CSE.
///
/// Returns:
/// - Production: API key dari environment variables (Cloudhebat)
/// - Development: API key dari environment variables atau default
String get googleCseApiKey {
  // === PRODUCTION ENVIRONMENT (Cloudhebat) ===
  const String productionKey = String.fromEnvironment('GOOGLE_CSE_API_KEY');

  if (productionKey.isNotEmpty && productionKey != 'your-api-key') {
    return productionKey;
  }

  // === FALLBACK ===
  // Nilai default saat build lokal—harus diganti sebelum produksi
  return 'AIzaSyAFOdoaMwgurnjfnhGKn5GFy6_m2HKiGtA';
}

/// === GOOGLE CSE CX CONFIGURATION ===
/// Getter function untuk Google Custom Search Engine Context (CX).
/// Digunakan untuk mengidentifikasi search engine yang digunakan.
///
/// Returns:
/// - Production: CX dari environment variables (Cloudhebat)
/// - Development: CX dari environment variables atau default
String get googleCseCx {
  // === PRODUCTION ENVIRONMENT (Cloudhebat) ===
  const String productionCx = String.fromEnvironment('GOOGLE_CSE_CX');

  if (productionCx.isNotEmpty && productionCx != 'your-cx-id') {
    return productionCx;
  }

  // === FALLBACK ===
  // Default CX untuk development/testing
  return '6242f5825dedb4b59';
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
const String searchEndpoint = '/api/search'; // Endpoint tunggal untuk pencarian klaim

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
