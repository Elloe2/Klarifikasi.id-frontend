// === KONFIGURASI API URL ===
// Konfigurasi base URL yang adaptif untuk development dan production
// Gunakan environment variable atau build config untuk production URL

import 'package:flutter/foundation.dart'; // Untuk kIsWeb detection

// === BASE URL CONFIGURATION ===
String get apiBaseUrl {
  // Development environment
  if (kDebugMode) {
    // Untuk Flutter web development dengan Laravel backend
    if (kIsWeb) {
      // Jika running di Flutter web, gunakan relative URL atau HTTPS
      return 'http://localhost:8000'; // Fallback untuk development
    }
    // Untuk mobile/desktop development
    return 'http://10.0.2.2:8000'; // Android emulator
  }

  // Production environment - GANTI DENGAN DOMAIN PRODUCTION ANDA
  return 'https://your-production-domain.com';
}

/// Endpoint Laravel API untuk pencarian.
const String searchEndpoint = '/api/search';

/// Endpoint untuk histori pencarian pengguna.
const String historyEndpoint = '/api/history';
