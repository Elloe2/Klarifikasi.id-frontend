/// Model untuk data analisis Gemini AI
class GeminiAnalysis {
  /// Menyatakan apakah pemanggilan Gemini berhasil memproses klaim
  final bool success;

  /// Ringkasan penjelasan yang disampaikan oleh Gemini
  final String explanation;

  /// Informasi sumber yang dirujuk (jika tersedia)
  final String sources;

  /// Analisis mendalam yang diberikan oleh Gemini
  final String analysis;

  /// Klaim asli yang dianalisis sehingga mudah ditampilkan ulang di UI
  final String claim;

  /// Pesan error jika proses analisis gagal
  final String? error;

  /// Constructor utama untuk membuat instance analisis
  const GeminiAnalysis({
    required this.success,
    required this.explanation,
    required this.sources,
    required this.analysis,
    required this.claim,
    this.error,
  });

  /// Factory constructor untuk mengubah response JSON menjadi objek model
  factory GeminiAnalysis.fromJson(Map<String, dynamic> json) {
    return GeminiAnalysis(
      success: json['success'] ?? false,
      explanation:
          _ensureString(json['explanation']) ?? 'Tidak ada penjelasan tersedia',
      sources: _ensureString(json['sources']) ?? 'Tidak ada sumber tersedia',
      analysis:
          _ensureString(json['analysis']) ?? 'Tidak ada analisis tersedia',
      claim: _ensureString(json['claim']) ?? '',
      error: _ensureString(json['error']),
    );
  }

  /// Helper method untuk memastikan value adalah string
  static String? _ensureString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is List) return value.join(' ');
    return value.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'explanation': explanation,
      'sources': sources,
      'analysis': analysis,
      'claim': claim,
      if (error != null) 'error': error,
    };
  }

  /// Getter untuk status analisis
  String get status {
    if (!success) return 'Gagal';
    return 'Berhasil';
  }
}
