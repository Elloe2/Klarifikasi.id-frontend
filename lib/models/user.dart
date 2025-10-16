/// ============================================================================
/// USER MODEL - KLARIFIKASI.ID FRONTEND
/// ============================================================================
/// Model class untuk merepresentasikan data pengguna dalam aplikasi.
/// Mengelola data profil pengguna yang didapat dari Laravel backend.
///
/// Struktur Data:
/// - id: Unique identifier pengguna
/// - name: Nama lengkap pengguna
/// - email: Alamat email pengguna
/// - birthDate: Tanggal lahir (opsional)
/// - age: Umur otomatis dihitung dari birth_date
/// - educationLevel: Tingkat pendidikan (sd/smp/sma/kuliah)
/// - educationDisplay: Format display pendidikan dalam bahasa Indonesia
/// - institution: Nama institusi/sekolah/kampus
/// ============================================================================
library;

/// === USER DATA MODEL ===
/// Class imutable untuk menyimpan informasi pengguna.
/// Digunakan untuk state management dan UI display.
///
/// Features:
/// - Immutable data class dengan final fields
/// - Factory constructor untuk parsing JSON dari API
/// - toJson() method untuk API requests
/// - copyWith() method untuk membuat objek baru dengan perubahan
/// - toString() override untuk debugging
///
/// Security:
/// - Tidak menyimpan password atau token sensitif
/// - Data bersifat read-only setelah konstruksi
/// - Validation dilakukan di AuthService sebelum parsing
class User {
  /// === REQUIRED FIELDS ===
  /// Fields yang wajib diisi saat membuat User object
  final int id; // Unique user identifier dari database
  final String name; // Nama lengkap pengguna
  final String email; // Alamat email pengguna (unique)

  /// === OPTIONAL FIELDS ===
  /// Fields yang bisa null dan digunakan untuk profil lengkap
  final String? birthDate; // Format: YYYY-MM-DD dari backend
  final int? age; // Diperoleh dari accessor getAgeAttribute() di backend
  final String? educationLevel; // Kode: 'sd'/'smp'/'sma'/'kuliah'
  final String? educationDisplay; // Format display: 'Sekolah Dasar', dll
  final String? institution; // Nama sekolah/kampus

  /// === CONSTRUCTOR ===
  /// Constructor dengan required fields untuk id, name, dan email.
  /// Optional fields untuk profil yang lebih lengkap.
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.birthDate,
    this.age,
    this.educationLevel,
    this.educationDisplay,
    this.institution,
  });

  /// === FACTORY CONSTRUCTOR - JSON PARSING ===
  /// Membuat User object dari response JSON Laravel backend.
  /// Mengkonversi snake_case dari backend ke camelCase untuk Dart.
  ///
  /// JSON Structure dari Backend:
  /// {
  ///   "id": 1,
  ///   "name": "John Doe",
  ///   "email": "john@example.com",
  ///   "birth_date": "1990-01-01",
  ///   "age": 33,
  ///   "education_level": "kuliah",
  ///   "education_display": "Mahasiswa",
  ///   "institution": "Universitas Indonesia"
  /// }
  ///
  /// Usage:
  /// ```dart
  /// final user = User.fromJson(jsonResponse['user']);
  /// ```
  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        id: json['id'] as int, // Cast ke int untuk type safety
        name: json['name'] as String, // Cast ke String untuk type safety
        email: json['email'] as String,
        birthDate: json['birth_date'] as String?, // Nullable field
        age: json['age'] as int?, // Nullable field
        educationLevel: json['education_level'] as String?, // Nullable field
        educationDisplay:
            json['education_display'] as String?, // Nullable field
        institution: json['institution'] as String?, // Nullable field
      );
    } catch (e) {
      throw FormatException('Failed to parse User from JSON: $e');
    }
  }

  /// === TO JSON METHOD ===
  /// Mengkonversi User object ke Map untuk dikirim ke API.
  /// Mengkonversi camelCase ke snake_case sesuai format backend.
  ///
  /// Return Map yang siap untuk HTTP request body:
  /// {
  ///   "name": "Updated Name",
  ///   "email": "newemail@example.com",
  ///   "birth_date": "1990-01-01",
  ///   "education_level": "kuliah",
  ///   "institution": "Universitas Indonesia"
  /// }
  ///
  /// Usage:
  /// ```dart
  /// final response = await http.post(
  ///   Uri.parse('$apiBaseUrl/api/auth/profile'),
  ///   headers: {'Content-Type': 'application/json'},
  ///   body: jsonEncode(user.toJson()),
  /// );
  /// ```
  Map<String, dynamic> toJson() {
    return {
      'name': name, // Nama lengkap pengguna
      'email': email, // Email address
      'birth_date': birthDate, // Format: YYYY-MM-DD
      'education_level': educationLevel, // Kode pendidikan
      'institution': institution, // Nama institusi
    };
  }

  /// === COPY WITH METHOD ===
  /// Membuat User object baru dengan beberapa field yang diubah.
  /// Menggunakan pattern immutable untuk state management yang aman.
  ///
  /// Parameters:
  /// - name: Nama baru (opsional)
  /// - email: Email baru (opsional)
  /// - birthDate: Tanggal lahir baru (opsional)
  /// - educationLevel: Tingkat pendidikan baru (opsional)
  /// - institution: Institusi baru (opsional)
  ///
  /// Return User object baru dengan field yang diupdate.
  ///
  /// Usage:
  /// ```dart
  /// final updatedUser = user.copyWith(
  ///   name: 'New Name',
  ///   institution: 'New University',
  /// );
  /// ```
  User copyWith({
    String? name,
    String? email,
    String? birthDate,
    String? educationLevel,
    String? institution,
  }) {
    return User(
      id: id, // ID tidak bisa diubah (immutable)
      name: name ?? this.name, // Gunakan nilai baru atau tetap yang lama
      email: email ?? this.email, // Gunakan nilai baru atau tetap yang lama
      birthDate: birthDate ?? this.birthDate, // Nullable field
      age: age, // Age tidak diubah karena dihitung otomatis
      educationLevel: educationLevel ?? this.educationLevel, // Nullable field
      educationDisplay:
          educationDisplay, // Display tidak diubah karena dihitung otomatis
      institution: institution ?? this.institution, // Nullable field
    );
  }

  /// === TO STRING OVERRIDE ===
  /// Override toString() untuk debugging dan logging.
  /// Menampilkan informasi penting tanpa data sensitif.
  ///
  /// Return format: "User(id: 1, name: John Doe, email: john@example.com)"
  ///
  /// Usage:
  /// ```dart
  /// print(user); // Output: User(id: 1, name: John Doe, email: john@example.com)
  /// ```
  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email)';
  }

  /// === ADDITIONAL HELPER METHODS ===
  /// Method tambahan untuk kemudahan penggunaan:

  /// Check apakah user memiliki profil lengkap
  bool get hasCompleteProfile {
    return birthDate != null && educationLevel != null && institution != null;
  }

  /// Get inisial nama untuk avatar
  String get initials {
    final nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  /// Check apakah user sudah verified (jika ada field email_verified_at)
  bool get isVerified {
    return true; // Sementara selalu true
  }
}

/// === USAGE EXAMPLES ===
///
/// 1. Parsing dari API response:
/// ```dart
/// final response = await http.get(Uri.parse('$apiBaseUrl/api/auth/profile'));
/// final json = jsonDecode(response.body);
/// final user = User.fromJson(json['user']);
/// ```
///
/// 2. Update profil pengguna:
/// ```dart
/// final updatedUser = user.copyWith(
///   name: 'Nama Baru',
///   institution: 'Universitas Baru',
/// );
/// await authService.updateProfile(updatedUser);
/// ```
///
/// 3. Display di UI:
/// ```dart
/// Text(user.name),
/// Text('${user.age} tahun'),
/// Text(user.educationDisplay ?? 'Tidak diisi'),
/// ```
///
/// === DATA FLOW ===
/// 1. Backend Laravel mengirim data dalam format snake_case
/// 2. User.fromJson() mengkonversi ke camelCase untuk Dart
/// 3. UI menggunakan data untuk display
/// 4. User.copyWith() membuat objek baru untuk update
/// 5. User.toJson() mengkonversi kembali ke snake_case untuk API
