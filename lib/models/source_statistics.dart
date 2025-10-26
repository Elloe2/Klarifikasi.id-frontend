/// ============================================================================
/// SOURCE STATISTICS MODEL - KLARIFIKASI.ID FRONTEND
/// ============================================================================
/// Model untuk merepresentasikan statistik agregat dari analisis sumber.
/// Berisi jumlah dan persentase sumber per kategori.
/// ============================================================================
library;

/// === SOURCE STATISTICS DATA MODEL ===
/// Class untuk menyimpan statistik agregat dari source analysis.
/// Digunakan untuk menampilkan progress bar dan summary di UI.
///
/// Features:
/// - Immutable data class dengan final fields
/// - Factory constructor untuk parsing JSON dari API
/// - Computed properties untuk persentase
/// - Helper methods untuk UI display
class SourceStatistics {
  /// === FIELDS ===
  /// Total jumlah sumber yang dianalisis
  final int totalSources;

  /// Jumlah sumber yang mendukung klaim
  final int supportCount;

  /// Jumlah sumber yang tidak mendukung/menolak klaim
  final int opposeCount;

  /// Jumlah sumber yang netral/ambigu
  final int neutralCount;

  /// === CONSTRUCTOR ===
  const SourceStatistics({
    required this.totalSources,
    required this.supportCount,
    required this.opposeCount,
    required this.neutralCount,
  });

  /// === FACTORY CONSTRUCTOR - JSON PARSING ===
  /// Membuat SourceStatistics object dari response JSON backend.
  ///
  /// JSON Structure dari Backend:
  /// {
  ///   "total_sources": 10,
  ///   "support_count": 7,
  ///   "oppose_count": 2,
  ///   "neutral_count": 1
  /// }
  ///
  /// Usage:
  /// ```dart
  /// final stats = SourceStatistics.fromJson(jsonData);
  /// ```
  factory SourceStatistics.fromJson(Map<String, dynamic> json) {
    return SourceStatistics(
      totalSources: json['total_sources'] as int? ?? 0,
      supportCount: json['support_count'] as int? ?? 0,
      opposeCount: json['oppose_count'] as int? ?? 0,
      neutralCount: json['neutral_count'] as int? ?? 0,
    );
  }

  /// === COMPUTED PROPERTIES - PERCENTAGES ===

  /// Get persentase sumber yang mendukung
  double get supportPercentage {
    if (totalSources == 0) return 0.0;
    return (supportCount / totalSources) * 100;
  }

  /// Get persentase sumber yang tidak mendukung
  double get opposePercentage {
    if (totalSources == 0) return 0.0;
    return (opposeCount / totalSources) * 100;
  }

  /// Get persentase sumber yang netral
  double get neutralPercentage {
    if (totalSources == 0) return 0.0;
    return (neutralCount / totalSources) * 100;
  }

  /// Get persentase sebagai string dengan 1 desimal
  String get supportPercentageStr =>
      supportPercentage.toStringAsFixed(1);
  String get opposePercentageStr =>
      opposePercentage.toStringAsFixed(1);
  String get neutralPercentageStr =>
      neutralPercentage.toStringAsFixed(1);

  /// === HELPER METHODS ===

  /// Get kategori dominan berdasarkan persentase
  String get dominantCategory {
    if (supportCount >= opposeCount && supportCount >= neutralCount) {
      return 'SUPPORT';
    } else if (opposeCount >= supportCount && opposeCount >= neutralCount) {
      return 'OPPOSE';
    } else {
      return 'NEUTRAL';
    }
  }

  /// Check apakah data valid
  bool get isValid => totalSources > 0;

  /// === TO JSON METHOD ===
  Map<String, dynamic> toJson() {
    return {
      'total_sources': totalSources,
      'support_count': supportCount,
      'oppose_count': opposeCount,
      'neutral_count': neutralCount,
    };
  }

  /// === TO STRING OVERRIDE ===
  @override
  String toString() {
    return 'SourceStatistics(total: $totalSources, support: $supportCount, oppose: $opposeCount, neutral: $neutralCount)';
  }
}
