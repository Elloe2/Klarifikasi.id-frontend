# flutter_application_laravel_1

Aplikasi Flutter yang akan terintegrasi dengan backend Laravel 12.x untuk melakukan pencarian informasi (fact-check) melalui Google Custom Search Engine.

## Struktur Proyek
- `lib/`: kode Flutter utama.
- `android/`, `ios/`, `web/`, dll.: folder platform bawaan Flutter.
- Backend Laravel disiapkan sebagai proyek terpisah (mis. `hoax-checker-backend/`).

## Konfigurasi Backend (Laravel 12.x)
1. Buat project Laravel baru.
2. Tambahkan pada file `.env`:
   ```env
   GOOGLE_CSE_KEY=your_google_cse_api_key
   GOOGLE_CSE_CX=your_programmable_search_engine_cx
   ```
3. Daftarkan di `config/services.php`:
   ```php
   'google_cse' => [
       'key' => env('GOOGLE_CSE_KEY'),
       'cx'  => env('GOOGLE_CSE_CX'),
   ],
   ```
4. Buat endpoint API (mis. `POST /api/search`) yang meneruskan query ke Google Custom Search.

> **Catatan:** Jangan commit kunci API asli ke repository publik. Simpan hanya di `.env` atau secret manager.

## Mendapatkan Google Custom Search Kredensial
1. Aktifkan **Custom Search API** di Google Cloud Console dan buat **API Key**.
2. Buat Programmable Search Engine dan salin **Search Engine ID (CX)**.
3. Simpan keduanya sebagai variabel environment di backend Laravel.

## Menjalankan Flutter App
```bash
flutter pub get
flutter run
```
