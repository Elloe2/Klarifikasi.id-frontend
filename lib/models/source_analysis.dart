/// ============================================================================
/// SOURCE ANALYSIS MODEL - KLARIFIKASI.ID FRONTEND
/// ============================================================================
/// Model untuk merepresentasikan analisis satu sumber dalam fact-checking.
/// Berisi informasi tentang stance sumber terhadap klaim.
/// ============================================================================
library;

/// === SOURCE ANALYSIS DATA MODEL ===
/// Class untuk menyimpan analisis detail satu sumber/artikel.
/// Digunakan untuk menampilkan breakdown sumber dalam UI.
///
/// Features:
/// - Immutable data class dengan final fields
/// - Factory constructor untuk parsing JSON dari API
/// - Helper methods untuk UI display
class SourceAnalysis {
  /// === FIELDS ===
  /// Index sumber dalam list (1-based)
  final int index;

  /// Stance sumber terhadap klaim: 'SUPPORT' / 'OPPOSE' / 'NEUTRAL'
  final String stance;

  /// Penjelasan singkat mengapa sumber memiliki stance ini
  final String reasoning;

  /// Kutipan relevan dari sumber (opsional)
  final String? quote;

  /// === CONSTRUCTOR ===
  const SourceAnalysis({
    required this.index,
    required this.stance,
    required this.reasoning,
    this.quote,
  });

  /// === FACTORY CONSTRUCTOR - JSON PARSING ===
  /// Membuat SourceAnalysis object dari response JSON backend.
  ///
  /// JSON Structure dari Backend:
  /// {
  ///   "index": 1,
  ///   "stance": "SUPPORT|OPPOSE|NEUTRAL",
  ///   "reasoning": "Penjelasan singkat",
  ///   "quote": "Kutipan dari sumber"
  /// }
  ///
  /// Usage:
  /// ```dart
  /// final sourceAnalysis = SourceAnalysis.fromJson(jsonData);
  /// ```
  factory SourceAnalysis.fromJson(Map<String, dynamic> json) {
    return SourceAnalysis(
      index: json['index'] as int? ?? 0,
      stance: json['stance'] as String? ?? 'NEUTRAL',
      reasoning: json['reasoning'] as String? ?? '',
      quote: json['quote'] as String?,
    );
  }

  /// === HELPER METHODS ===

  /// Get readable text untuk stance
  String get stanceText {
    switch (stance) {
      case 'SUPPORT':
        return 'Mendukung';
      case 'OPPOSE':
        return 'Tidak Mendukung';
      case 'NEUTRAL':
        return 'Netral';
      default:
        return 'Unknown';
    }
  }

  /// Get color untuk stance badge
  String get stanceColor {
    switch (stance) {
      case 'SUPPORT':
        return '#10B981'; // Green
      case 'OPPOSE':
        return '#EF4444'; // Red
      case 'NEUTRAL':
        return '#F59E0B'; // Yellow
      default:
        return '#6B7280'; // Gray
    }
  }

  /// Check apakah sumber memiliki kutipan
  bool get hasQuote => quote != null && quote!.isNotEmpty;

  /// === TO JSON METHOD ===
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'stance': stance,
      'reasoning': reasoning,
      if (quote != null) 'quote': quote,
    };
  }

  /// === TO STRING OVERRIDE ===
  @override
  String toString() {
    return 'SourceAnalysis(index: $index, stance: $stance, reasoning: $reasoning)';
  }
}
