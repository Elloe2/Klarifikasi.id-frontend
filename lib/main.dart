/// ============================================================================
/// ENTRY POINT - KLARIFIKASI.ID FLUTTER APPLICATION
/// ============================================================================
/// File ini adalah entry point utama aplikasi Flutter.
/// Menginisialisasi dan menjalankan aplikasi dengan konfigurasi dasar.
///
/// Struktur:
/// - main(): Function entry point yang memanggil runApp()
/// - MainApp: Root widget aplikasi dengan konfigurasi MaterialApp
/// ============================================================================
library;

import 'package:flutter/material.dart'; // Flutter Material Design widgets

import 'app/app.dart'; // Import MainApp widget dari folder app/

/// === MAIN ENTRY POINT ===
/// Function utama yang dieksekusi pertama kali ketika aplikasi dijalankan.
/// Memanggil runApp() untuk memulai Flutter application.
///
/// Tidak ada konfigurasi khusus di sini karena semua konfigurasi
/// aplikasi dilakukan di dalam MainApp widget.
///
/// Best Practices:
/// - Keep main() function sesederhana mungkin
/// - Semua konfigurasi dilakukan di widget tree
/// - Error handling dilakukan di root widget
///
/// Usage:
/// ```bash
/// flutter run -d chrome  # Jalankan di browser
/// flutter run -d android # Jalankan di Android
/// ```
void main() {
  // Jalankan aplikasi dengan MainApp sebagai root widget
  // MainApp berisi semua konfigurasi aplikasi termasuk:
  // - Theme configuration
  // - Route definitions
  // - Provider setup untuk state management
  // - Authentication flow
  runApp(const MainApp());
}
