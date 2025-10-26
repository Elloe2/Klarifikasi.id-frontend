import 'source_analysis.dart';
import 'source_statistics.dart';
import 'accuracy_score.dart';

/// Model untuk data analisis Gemini AI
/// Enhanced version dengan source analysis dan accuracy scoring
class GeminiAnalysis {
  /// Menyatakan apakah pemanggilan Gemini berhasil memproses klaim
  final bool success;

  /// Ringkasan penjelasan yang disampaikan oleh Gemini
  final String explanation;

  /// Analisis mendalam yang diberikan oleh Gemini
  final String? detailedAnalysis;

  /// Klaim asli yang dianalisis sehingga mudah ditampilkan ulang di UI
  final String claim;

  /// Pesan error jika proses analisis gagal
  final String? error;

  /// NEW: Analisis detail setiap sumber
  final List<SourceAnalysis>? sourceAnalysis;

  /// NEW: Statistik agregat dari source analysis
  final SourceStatistics? statistics;

  /// NEW: Skor akurasi dan verdict
  final AccuracyScore? accuracyScore;

  /// Constructor utama untuk membuat instance analisis
  const GeminiAnalysis({
    required this.success,
    required this.explanation,
    required this.claim,
    this.detailedAnalysis,
    this.error,
    this.sourceAnalysis,
    this.statistics,
    this.accuracyScore,
  });

  /// Factory constructor untuk mengubah response JSON menjadi objek model
  /// Enhanced version dengan support untuk new fields
  factory GeminiAnalysis.fromJson(Map<String, dynamic> json) {
    // Parse source analysis list
    List<SourceAnalysis>? sourceAnalysisList;
    if (json['source_analysis'] != null && json['source_analysis'] is List) {
      sourceAnalysisList = (json['source_analysis'] as List)
          .map((item) => SourceAnalysis.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    // Parse statistics
    SourceStatistics? stats;
    if (json['statistics'] != null && json['statistics'] is Map) {
      stats = SourceStatistics.fromJson(
          json['statistics'] as Map<String, dynamic>);
    }

    // Parse accuracy score
    AccuracyScore? score;
    if (json['accuracy_score'] != null && json['accuracy_score'] is Map) {
      score = AccuracyScore.fromJson(
          json['accuracy_score'] as Map<String, dynamic>);
    }

    return GeminiAnalysis(
      success: json['success'] ?? false,
      explanation: _ensureString(json['explanation']) ??
          'Tidak ada penjelasan tersedia',
      detailedAnalysis: _ensureString(json['detailed_analysis']) ??
          _ensureString(json['analysis']),
      claim: _ensureString(json['claim']) ?? '',
      error: _ensureString(json['error']),
      sourceAnalysis: sourceAnalysisList,
      statistics: stats,
      accuracyScore: score,
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
      'detailed_analysis': detailedAnalysis,
      'claim': claim,
      if (error != null) 'error': error,
      if (sourceAnalysis != null)
        'source_analysis': sourceAnalysis!.map((s) => s.toJson()).toList(),
      if (statistics != null) 'statistics': statistics!.toJson(),
      if (accuracyScore != null) 'accuracy_score': accuracyScore!.toJson(),
    };
  }

  /// Getter untuk status analisis
  String get status {
    if (!success) return 'Gagal';
    return 'Berhasil';
  }

  /// Check apakah memiliki enhanced data
  bool get hasEnhancedData =>
      sourceAnalysis != null && statistics != null && accuracyScore != null;
}
