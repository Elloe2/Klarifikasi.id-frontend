/// Model untuk data analisis Gemini AI
class GeminiAnalysis {
  /// Menyatakan apakah pemanggilan Gemini berhasil memproses klaim
  final bool success;

  /// Verdict analisis: DIDUKUNG_DATA, TIDAK_DIDUKUNG_DATA, MEMERLUKAN_VERIFIKASI
  final String verdict;

  /// Ringkasan penjelasan yang disampaikan oleh Gemini
  final String explanation;

  /// Analisis mendalam yang diberikan oleh Gemini
  final String analysis;

  /// Confidence level: tinggi, sedang, rendah
  final String confidence;

  /// Informasi sumber yang dirujuk (jika tersedia)
  final String sources;

  /// Klaim asli yang dianalisis sehingga mudah ditampilkan ulang di UI
  final String claim;

  /// Pesan error jika proses analisis gagal
  final String? error;

  /// Constructor utama untuk membuat instance analisis
  const GeminiAnalysis({
    required this.success,
    required this.verdict,
    required this.explanation,
    required this.analysis,
    required this.confidence,
    required this.sources,
    required this.claim,
    this.error,
  });

  /// Factory constructor untuk mengubah response JSON menjadi objek model
  factory GeminiAnalysis.fromJson(Map<String, dynamic> json) {
    return GeminiAnalysis(
      success: json['success'] ?? false,
      verdict: _ensureString(json['verdict']) ?? 'MEMERLUKAN_VERIFIKASI',
      explanation:
          _ensureString(json['explanation']) ?? 'Tidak ada penjelasan tersedia',
      analysis:
          _ensureString(json['analysis']) ?? 'Tidak ada analisis tersedia',
      confidence: _ensureString(json['confidence']) ?? 'rendah',
      sources: _ensureString(json['sources']) ?? '',
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
      'verdict': verdict,
      'explanation': explanation,
      'analysis': analysis,
      'confidence': confidence,
      'sources': sources,
      'claim': claim,
      if (error != null) 'error': error,
    };
  }

  /// Getter untuk status analisis
  String get status {
    if (!success) return 'Gagal';
    return 'Berhasil';
  }

  /// Getter untuk verdict display text
  String get verdictDisplay {
    switch (verdict) {
      case 'DIDUKUNG_DATA':
        return 'Didukung Data';
      case 'TIDAK_DIDUKUNG_DATA':
        return 'Tidak Didukung Data';
      case 'MEMERLUKAN_VERIFIKASI':
        return 'Memerlukan Verifikasi';
      default:
        return verdict;
    }
  }

  /// Getter untuk confidence display text
  String get confidenceDisplay {
    switch (confidence.toLowerCase()) {
      case 'tinggi':
        return 'Tinggi';
      case 'sedang':
        return 'Sedang';
      case 'rendah':
        return 'Rendah';
      default:
        return confidence;
    }
  }

  /// Getter untuk verdict color
  String get verdictColorClass {
    switch (verdict) {
      case 'DIDUKUNG_DATA':
        return 'success'; // Green
      case 'TIDAK_DIDUKUNG_DATA':
        return 'danger'; // Red
      case 'MEMERLUKAN_VERIFIKASI':
        return 'warning'; // Yellow
      default:
        return 'info';
    }
  }
}
