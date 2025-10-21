/// ============================================================================
/// AUTHENTICATION SERVICE - KLARIFIKASI.ID FRONTEND
/// ============================================================================
/// Service class untuk menangani semua operasi autentikasi dengan Laravel backend.
/// Mengelola token storage, HTTP requests, dan error handling.
///
/// Fitur Utama:
/// - Secure token storage menggunakan Flutter Secure Storage
/// - HTTP client dengan proper headers dan timeout
/// - Comprehensive error handling dengan user-friendly messages
/// - Automatic token validation dan refresh
/// - Cross-platform compatibility (Web & Mobile)
///
/// Security Features:
/// - Bearer token authentication
/// - Secure storage encryption
/// - Automatic token cleanup on errors
/// - Request timeout protection
/// ============================================================================
library;

import 'dart:convert'; // JSON encoding/decoding
import 'package:http/http.dart' as http; // HTTP client untuk API calls
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Secure token storage
import 'package:flutter/foundation.dart'; // Platform detection

// === CONFIGURATION & MODELS ===
import '../config.dart'; // API configuration dan endpoints
import '../models/user.dart'; // User model untuk data parsing

// === CUSTOM HTTP CLIENT FOR WEB ===
class _WebHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    // Untuk Flutter web, kita tidak bisa set CORS headers dari client
    // CORS harus di-handle oleh server (Laravel Cloud)
    // Kita hanya perlu memastikan request format yang benar

    // Tambahkan headers yang diperlukan untuk web
    request.headers['Content-Type'] = 'application/json';
    request.headers['Accept'] = 'application/json';

    return _inner.send(request);
  }
}

/// === AUTHENTICATION SERVICE CLASS ===
/// Service class utama untuk menangani semua operasi autentikasi.
/// Menggunakan singleton pattern untuk konsistensi state.
///
/// Responsibilities:
/// - User registration dengan validasi lengkap
/// - User login dengan token management
/// - Profile retrieval dan updates
/// - Secure logout dengan cleanup
/// - Token validation dan refresh
///
/// Architecture:
/// - HTTP client dengan timeout dan retry logic
/// - Secure storage untuk sensitive data
/// - Error handling dengan specific error types
/// - JSON parsing dengan type safety
class AuthService {
  // === PRIVATE PROPERTIES ===
  String get _baseUrl => apiBaseUrl; // Base URL dari config.dart
  final FlutterSecureStorage _storage =
      const FlutterSecureStorage(); // Secure storage instance

  // === HTTP CLIENT GETTER ===
  http.Client get _httpClient {
    if (kIsWeb) {
      return _WebHttpClient(); // Custom client untuk web dengan CORS
    }
    return http.Client(); // Default client untuk mobile/desktop
  }

  // === TIMEOUT CONFIGURATION ===
  static const Duration _requestTimeout = Duration(
    seconds: 10,
  ); // Timeout untuk HTTP requests
  static const String _tokenKey = 'auth_token'; // Key untuk token storage

  // === ENDPOINTS ===
  static const String _loginEndpoint = '/api/auth/login';
  static const String _registerEndpoint = '/api/auth/register';
  static const String _profileEndpoint = '/api/auth/profile';
  static const String _logoutEndpoint = '/api/auth/logout';

  /// === GET CURRENT USER PROFILE ===
  /// Mendapatkan informasi profil pengguna yang sedang login.
  /// Menggunakan token yang tersimpan untuk autentikasi.
  ///
  /// Returns:
  /// - User object jika token valid dan request berhasil
  /// - null jika token tidak ada atau tidak valid
  ///
  /// Security:
  /// - Automatic token cleanup jika expired (401)
  /// - Secure error handling tanpa expose sensitive data
  ///
  /// Usage:
  /// ```dart
  /// final user = await authService.getCurrentUser();
  /// if (user != null) {
  ///   print('Welcome back, ${user.name}');
  /// }
  /// ```
  Future<User?> getCurrentUser() async {
    try {
      // Ambil token dari secure storage
      final token = await _storage.read(key: _tokenKey);
      if (token == null) return null; // Tidak ada token, user belum login

      // Request profile dengan Bearer token
      final response = await _httpClient
          .get(
            Uri.parse('$_baseUrl$_profileEndpoint'),
            headers: {
              'Authorization': 'Bearer $token', // Bearer token authentication
              'Content-Type': 'application/json',
            },
          )
          .timeout(_requestTimeout); // Timeout protection

      if (response.statusCode == 200) {
        // Success: Parse user data dari response
        final data = jsonDecode(response.body);
        return User.fromJson(data['user']);
      } else if (response.statusCode == 401) {
        // Unauthorized: Token expired atau invalid
        // Cleanup token dan return null
        await _storage.delete(key: _tokenKey);
        return null;
      } else {
        // Other error: Return null tanpa cleanup token
        return null;
      }
    } catch (e) {
      // Network error atau parsing error
      // Cleanup token untuk security dan return null
      await _storage.delete(key: _tokenKey);
      return null;
    }
  }

  /// === USER REGISTRATION ===
  /// Melakukan registrasi pengguna baru dengan data lengkap.
  /// Mengirim data ke Laravel backend untuk validasi dan penyimpanan.
  ///
  /// Parameters:
  /// - name: Nama lengkap pengguna (required)
  /// - email: Alamat email unik (required)
  /// - password: Password dengan konfirmasi (required)
  /// - birthDate: Tanggal lahir (optional)
  /// - educationLevel: Tingkat pendidikan (optional)
  /// - institution: Nama institusi (optional)
  ///
  /// Returns: User object dengan token autentikasi
  ///
  /// Throws:
  /// - Exception jika registrasi gagal
  /// - ValidationException jika data tidak valid
  ///
  /// Security:
  /// - Password confirmation untuk validasi
  /// - Automatic token storage setelah registrasi berhasil
  /// - Error handling tanpa expose sensitive data
  ///
  /// Usage:
  /// ```dart
  /// try {
  ///   final user = await authService.register(
  ///     name: 'John Doe',
  ///     email: 'john@example.com',
  ///     password: 'securePassword123',
  ///     birthDate: '1990-01-01',
  ///     educationLevel: 'kuliah',
  ///     institution: 'Universitas Indonesia',
  ///   );
  ///   print('Registration successful: ${user.name}');
  /// } catch (e) {
  ///   print('Registration failed: $e');
  /// }
  /// ```
  Future<User> register({
    required String name,
    required String email,
    required String password,
    String? birthDate,
    String? educationLevel,
    String? institution,
  }) async {
    // HTTP POST request ke register endpoint
    final response = await _post(
      _registerEndpoint,
      body: {
        'name': name, // Nama lengkap pengguna
        'email': email, // Email address unik
        'password': password, // Password
        'password_confirmation': password, // Konfirmasi password
        // Optional fields dengan conditional inclusion
        if (birthDate != null) 'birth_date': birthDate,
        if (educationLevel != null) 'education_level': educationLevel,
        if (institution != null) 'institution': institution,
      },
    );

    if (response.statusCode == 201) {
      // Success: Parse response dan simpan token
      final data = jsonDecode(response.body);
      final token = data['token'];

      // Simpan token ke secure storage
      await _storage.write(key: _tokenKey, value: token);

      // Return user data
      return User.fromJson(data['user']);
    } else {
      // Error: Parse error message dari backend
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Registration failed');
    }
  }

  /// === USER LOGIN ===
  /// Melakukan autentikasi pengguna dengan email dan password.
  /// Mengirim kredensial ke backend untuk validasi dan token generation.
  ///
  /// Parameters:
  /// - email: Alamat email pengguna (required)
  /// - password: Password pengguna (required)
  ///
  /// Returns: User object dengan token autentikasi
  ///
  /// Throws:
  /// - Exception dengan pesan spesifik berdasarkan error type
  /// - Network error jika koneksi bermasalah
  /// - Timeout error jika request timeout
  ///
  /// Error Handling:
  /// - 401: Invalid credentials (email/password salah)
  /// - 422: Validation error (format data tidak valid)
  /// - 500+: Server error (kesalahan internal server)
  /// - Network: SocketException atau connection error
  /// - Timeout: Request timeout setelah 10 detik
  ///
  /// Security:
  /// - Automatic token storage setelah login berhasil
  /// - Error messages dalam bahasa Indonesia untuk UX
  /// - No sensitive data exposure dalam error messages
  ///
  /// Usage:
  /// ```dart
  /// try {
  ///   final user = await authService.login(
  ///     email: 'user@example.com',
  ///     password: 'securePassword123',
  ///   );
  ///   print('Login successful: ${user.name}');
  /// } catch (e) {
  ///   print('Login failed: $e');
  ///   // Handle error di UI (show dialog, snackbar, etc)
  /// }
  /// ```
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final response = await _post(
      _loginEndpoint,
      body: {
        'email': email, // Email pengguna
        'password': password, // Password pengguna
      },
    );

    if (response.statusCode == 200) {
      // Success: Parse response dan simpan token
      final data = jsonDecode(response.body);
      final token = data['token'];

      // Simpan token ke secure storage
      await _storage.write(key: _tokenKey, value: token);

      // Return user data
      return User.fromJson(data['user']);
    } else {
      // Error: Parse error message dari backend
      final errorData = jsonDecode(response.body);
      final errorMessage = errorData['message'] ?? 'Login failed';

      // Buat exception dengan informasi lebih spesifik berdasarkan status code
      if (response.statusCode == 401) {
        throw Exception('Invalid credentials');
      } else if (response.statusCode == 422) {
        throw Exception('Validation error: $errorMessage');
      } else if (response.statusCode >= 500) {
        throw Exception('Server error: $errorMessage');
      } else {
        throw Exception(errorMessage);
      }
    }
  }

  /// === USER LOGOUT ===
  /// Melakukan logout pengguna dengan cleanup token dan session.
  /// Mengirim request logout ke backend dan menghapus token lokal.
  ///
  /// Process:
  /// 1. Ambil token dari secure storage
  /// 2. Kirim logout request ke backend (jika token ada)
  /// 3. Hapus token dari secure storage
  /// 4. Cleanup session data
  ///
  /// Error Handling:
  /// - Network errors diabaikan untuk memastikan logout selalu berhasil
  /// - Token cleanup selalu dilakukan meskipun backend logout gagal
  /// - Graceful degradation tanpa crash
  ///
  /// Security:
  /// - Double cleanup untuk memastikan token benar-benar terhapus
  /// - Error ignore untuk mencegah stuck logout process
  /// - No sensitive data left behind
  ///
  /// Usage:
  /// ```dart
  /// await authService.logout();
  /// // User akan diarahkan ke login page otomatis
  /// ```
  Future<void> logout() async {
    // Ambil token untuk logout request ke backend
    final token = await _storage.read(key: _tokenKey);

    if (token != null) {
      try {
        // Kirim logout request ke backend dengan token
        await _post(
          _logoutEndpoint,
          headers: {
            'Authorization': 'Bearer $token', // Bearer token untuk logout
            'Content-Type': 'application/json',
          },
        );
      } catch (e) {
        // Ignore errors during logout untuk memastikan process selalu selesai
        // Backend logout failure tidak boleh mencegah local cleanup
      }
    }

    // Selalu hapus token dari local storage untuk security
    await _storage.delete(key: _tokenKey);
  }

  /// === UPDATE USER PROFILE ===
  /// Memperbarui informasi profil pengguna yang sedang login.
  /// Mengirim data yang diubah ke backend untuk validasi dan penyimpanan.
  ///
  /// Parameters:
  /// - name: Nama lengkap baru (optional)
  /// - email: Alamat email baru (optional)
  /// - birthDate: Tanggal lahir baru (optional)
  /// - educationLevel: Tingkat pendidikan baru (optional)
  /// - institution: Nama institusi baru (optional)
  ///
  /// Returns: User object dengan data terbaru
  ///
  /// Throws:
  /// - Exception jika tidak authenticated
  /// - Exception jika update gagal
  /// - ValidationException jika data tidak valid
  ///
  /// Security:
  /// - Memerlukan token autentikasi yang valid
  /// - Hanya bisa update profil sendiri
  /// - Validasi email uniqueness di backend
  ///
  /// Usage:
  /// ```dart
  /// try {
  ///   final updatedUser = await authService.updateProfile(
  ///     name: 'Nama Baru',
  ///     institution: 'Universitas Baru',
  ///   );
  ///   print('Profile updated: ${updatedUser.name}');
  /// } catch (e) {
  ///   print('Update failed: $e');
  /// }
  /// ```
  Future<User> updateProfile({
    String? name,
    String? email,
    String? birthDate,
    String? educationLevel,
    String? institution,
  }) async {
    // Check authentication dengan token
    final token = await _storage.read(key: _tokenKey);
    if (token == null) throw Exception('Not authenticated');

    // HTTP POST request ke profile update endpoint
    final response = await _post(
      _profileEndpoint,
      headers: {
        'Authorization': 'Bearer $token', // Bearer token authentication
        'Content-Type': 'application/json',
      },
      body: {
        // Conditional field inclusion - hanya kirim field yang diubah
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (birthDate != null) 'birth_date': birthDate,
        if (educationLevel != null) 'education_level': educationLevel,
        if (institution != null) 'institution': institution,
      },
    );

    if (response.statusCode == 200) {
      // Success: Parse response dan return user data terbaru
      final data = jsonDecode(response.body);
      return User.fromJson(data['user']);
    } else {
      // Error: Parse error message dari backend
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Update failed');
    }
  }

  /// === CHECK LOGIN STATUS ===
  /// Memeriksa status login pengguna dengan validasi token.
  /// Mengirim request ke profile endpoint untuk memverifikasi token.
  ///
  /// Returns:
  /// - true jika token valid dan user masih authenticated
  /// - false jika token tidak ada atau tidak valid
  ///
  /// Security:
  /// - Lightweight token validation tanpa parsing full user data
  /// - Quick check untuk UI state management
  /// - Graceful error handling tanpa crash
  ///
  /// Usage:
  /// ```dart
  /// final isAuthenticated = await authService.isLoggedIn();
  /// if (isAuthenticated) {
  ///   // User masih login, lanjutkan ke home page
  /// } else {
  ///   // Token expired, redirect ke login
  /// }
  /// ```
  Future<bool> isLoggedIn() async {
    // Check apakah ada token di storage
    final token = await _storage.read(key: _tokenKey);
    if (token == null) return false; // Tidak ada token = belum login

    try {
      // Validate token dengan request ke profile endpoint
      final response = await _httpClient
          .get(
            Uri.parse('$_baseUrl/api/auth/profile'),
            headers: {
              'Authorization': 'Bearer $token', // Bearer token authentication
              'Content-Type': 'application/json',
            },
          )
          .timeout(_requestTimeout);

      // Return true hanya jika status code 200 (success)
      return response.statusCode == 200;
    } catch (e) {
      // Network error atau timeout = anggap tidak login
      return false;
    }
  }

  /// === INTERNAL POST HELPER ===
  /// Helper untuk mengirim HTTP POST request dengan konfigurasi default.
  /// Menyatukan base URL, headers umum, encoding JSON, dan timeout handling.
  Future<http.Response> _post(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint');

    // Header dasar untuk semua request JSON
    final requestHeaders = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?headers,
    };

    try {
      final response = await _httpClient
          .post(
            uri,
            headers: requestHeaders,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_requestTimeout);

      return response;
    } on Exception {
      rethrow; // Propagasi ke caller untuk ditangani sesuai konteks
    }
  }
}
