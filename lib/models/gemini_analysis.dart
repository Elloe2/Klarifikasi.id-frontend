import 'source_analysis.dart';

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

  /// Label verdict akhir: HOAX, RAGU-RAGU, atau FAKTA
  final String verdictLabel;

  /// Skor dukungan (0-100) berdasarkan perbandingan sumber
  final double verdictScore;

  /// Penjelasan alasan verdict
  final String verdictReason;

  /// Jumlah sumber yang mendukung klaim
  final int supportingSources;

  /// Jumlah sumber yang tidak mendukung atau tidak terkait langsung dengan klaim
  final int nonSupportingSources;

  /// Jumlah total sumber yang dianalisis
  final int totalSources;

  /// Rincian analisis per sumber
  final List<SourceAnalysis> sourceBreakdown;

  /// Constructor utama untuk membuat instance analisis
  const GeminiAnalysis({
    required this.success,
    required this.explanation,
    required this.sources,
    required this.analysis,
    required this.claim,
    required this.verdictLabel,
    required this.verdictScore,
    required this.verdictReason,
    required this.supportingSources,
    required this.nonSupportingSources,
    required this.totalSources,
    required this.sourceBreakdown,
    this.error,
  });

  /// Factory constructor untuk mengubah response JSON menjadi objek model
  factory GeminiAnalysis.fromJson(Map<String, dynamic> json) {
    final verdict = json['verdict'] as Map<String, dynamic>? ?? const {};
    final rawSources = (json['source_breakdown'] as List<dynamic>?)
            ?.cast<Map<String, dynamic>>() ??
        const <Map<String, dynamic>>[];

    return GeminiAnalysis(
      success: json['success'] ?? false,
      explanation:
          _ensureString(json['explanation']) ?? 'Tidak ada penjelasan tersedia',
      sources: _ensureString(json['sources']) ?? 'Tidak ada sumber tersedia',
      analysis:
          _ensureString(json['analysis']) ?? 'Tidak ada analisis tersedia',
      claim: _ensureString(json['claim']) ?? '',
      verdictLabel:
          _ensureString(verdict['label'])?.toUpperCase() ?? 'RAGU-RAGU',
      verdictScore:
          double.tryParse(_ensureString(verdict['score']) ?? '') ??
          (verdict['score'] is num ? (verdict['score'] as num).toDouble() : 0),
      verdictReason:
          _ensureString(verdict['reason']) ?? 'Tidak ada penjelasan verdict.',
      supportingSources: verdict['supporting_sources'] as int? ?? 0,
      nonSupportingSources: verdict['non_supporting_sources'] as int? ??
          verdict['opposing_sources'] as int? ??
          verdict['neutral_sources'] as int? ?? 0,
      totalSources: verdict['total_sources'] as int? ?? 0,
      sourceBreakdown: List<SourceAnalysis>.generate(
        rawSources.length,
        (index) => SourceAnalysis.fromJson(rawSources[index], index + 1),
      ),
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
      'verdict': {
        'label': verdictLabel,
        'score': verdictScore,
        'reason': verdictReason,
        'supporting_sources': supportingSources,
        'non_supporting_sources': nonSupportingSources,
        'total_sources': totalSources,
      },
      'source_breakdown': sourceBreakdown.map((s) => s.toJson()).toList(),
      if (error != null) 'error': error,
    };
  }

  /// Getter untuk status analisis
  String get status => success ? 'Berhasil' : 'Gagal';

  /// True jika verdict menyatakan klaim sebagai fakta
  bool get isFact => verdictLabel == 'FAKTA';

  /// True jika verdict menyatakan klaim sebagai hoax
  bool get isHoax => verdictLabel == 'HOAX';

  /// True jika verdict menyatakan klaim masih ambigu
  bool get isAmbiguous => verdictLabel == 'RAGU-RAGU';

  /// Persentase dukungan (0-100)
  double get supportPercentage => totalSources == 0
      ? 0
      : (supportingSources / totalSources * 100);
}
