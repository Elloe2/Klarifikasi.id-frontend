# Klarifikasi.id (Flutter)

Aplikasi mobile Flutter untuk membantu klarifikasi berita/hoaks melalui integrasi Google Custom Search Engine dengan backend Laravel.

## Struktur Proyek
- `lib/`
  - `main.dart`: entry app dengan tab untuk pencarian, riwayat, dan pengaturan.
  - `models/`: representasi data (`SearchResult`, `SearchHistoryEntry`).
  - `services/`: komunikasi REST ke backend Laravel.
- `android/`, `ios/`: target platform utama aplikasi.
- `web/`: build opsional untuk preview web (boleh diabaikan saat release Android).
- Folder platform lain (`macos/`, `linux/`, `windows/`) dapat dihapus bila hanya fokus Android; saat ini dibiarkan agar tidak mengganggu build.
- Backend Laravel terpisah berada di `../hoax-checker-backend/`.

## Menjalankan Aplikasi
```bash
flutter pub get
flutter run
```
Pilih device Android emulator/perangkat fisik saat diminta.

## Backend Laravel (ringkas)
- Endpoint `POST /api/search` meneruskan query ke Google Custom Search dan menyimpan riwayat.
- Endpoint `GET /api/history` menampilkan histori pencarian pengguna.
- Pastikan `.env` pada backend memuat `GOOGLE_CSE_KEY`, `GOOGLE_CSE_CX`, dan jalankan migrasi `php artisan migrate`.

## Catatan
- Jangan commit kredensial sensitif ke repo.
- Untuk produksi, aktifkan kembali verifikasi SSL pada backend (`GOOGLE_CSE_VERIFY_SSL=true`).
