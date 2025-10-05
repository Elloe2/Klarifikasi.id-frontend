# Klarifikasi.id (Flutter)

Aplikasi mobile Flutter untuk membantu klasifikasi berita/hoaks melalui integrasi Google Custom Search Engine dengan backend Laravel.

## Struktur Proyek
- `lib/`
  - `main.dart`: titik masuk aplikasi berisi navigasi tab (Cari, Riwayat, Pengaturan) dan pengaturan tema.
  - `config.dart`: menyimpan konstanta konfigurasi seperti `apiBaseUrl` dan endpoint REST.
  - `models/`: tipe data sederhana yang merepresentasikan hasil pencarian dan entri riwayat.
  - `services/`: lapisan API (`SearchApi`) untuk memanggil backend Laravel.
- `android/`: berisi konfigurasi build Android .
- `web/`: aset dan konfigurasi build Flutter Web (index.html, manifest, ikon).
- `test/`: kumpulan widget/unit test (mis. `widget_test.dart`).
- `analysis_options.yaml`: aturan linter proyek.
- Backend Laravel terpisah berada di `../Klarifikasi.id-backend/`.