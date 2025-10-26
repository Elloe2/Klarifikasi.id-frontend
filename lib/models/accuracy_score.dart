/// ============================================================================
/// ACCURACY SCORE MODEL - KLARIFIKASI.ID FRONTEND
/// ============================================================================
/// Model untuk merepresentasikan skor akurasi dan verdict dari analisis klaim.
/// Berisi verdict (FAKTA/RAGU-RAGU/HOAX), confidence, dan rekomendasi.
/// ============================================================================
library;

/// === ACCURACY SCORE DATA MODEL ===
/// Class untuk menyimpan skor akurasi dan verdict dari Gemini analysis.
/// Digunakan untuk menampilkan verdict badge dan rekomendasi di UI.
///
/// Features:
/// - Immutable data class dengan final fields
/// - Factory constructor untuk parsing JSON dari API
/// - Helper methods untuk UI display dan color mapping
class AccuracyScore {
  /// === FIELDS ===
  /// Verdict: 'FAKTA' / 'RAGU-RAGU' / 'HOAX'
  final String verdict;

  /// Confidence score (0-100)
  final int confidence;

  /// Penjelasan mengapa diberikan verdict ini
  final String reasoning;

  /// Rekomendasi untuk user
  final String recommendation;

  /// === CONSTRUCTOR ===
  const AccuracyScore({
    required this.verdict,
    required this.confidence,
    required this.reasoning,
    required this.recommendation,
  });

  /// === FACTORY CONSTRUCTOR - JSON PARSING ===
  /// Membuat AccuracyScore object dari response JSON backend.
  ///
  /// JSON Structure dari Backend:
  /// {
  ///   "verdict": "FAKTA|RAGU-RAGU|HOAX",
  ///   "confidence": 85,
  ///   "reasoning": "Penjelasan mengapa verdict ini diberikan",
  ///   "recommendation": "Rekomendasi untuk user"
  /// }
  ///
  /// Usage:
  /// ```dart
  /// final score = AccuracyScore.fromJson(jsonData);
  /// ```
  factory AccuracyScore.fromJson(Map<String, dynamic> json) {
    return AccuracyScore(
      verdict: json['verdict'] as String? ?? 'RAGU-RAGU',
      confidence: json['confidence'] as int? ?? 50,
      reasoning: json['reasoning'] as String? ?? '',
      recommendation: json['recommendation'] as String? ?? '',
    );
  }

  /// === HELPER METHODS ===

  /// Get color untuk verdict badge
  /// FAKTA: Green, RAGU-RAGU: Yellow, HOAX: Red
  String get verdictColor {
    switch (verdict) {
      case 'FAKTA':
        return '#10B981'; // Green
      case 'RAGU-RAGU':
        return '#F59E0B'; // Yellow
      case 'HOAX':
        return '#EF4444'; // Red
      default:
        return '#6B7280'; // Gray
    }
  }

  /// Get icon untuk verdict
  String get verdictIcon {
    switch (verdict) {
      case 'FAKTA':
        return '✓'; // Check mark
      case 'RAGU-RAGU':
        return '?'; // Question mark
      case 'HOAX':
        return '✗'; // X mark
      default:
        return '○'; // Circle
    }
  }

  /// Get description untuk verdict
  String get verdictDescription {
    switch (verdict) {
      case 'FAKTA':
        return 'Klaim ini didukung oleh bukti yang kuat dari sumber terpercaya.';
      case 'RAGU-RAGU':
        return 'Klaim ini memiliki bukti yang beragam dan memerlukan verifikasi lebih lanjut.';
      case 'HOAX':
        return 'Klaim ini tidak didukung oleh bukti dan kemungkinan besar adalah hoax.';
      default:
        return 'Status klaim tidak dapat ditentukan.';
    }
  }

  /// Check apakah verdict adalah FAKTA
  bool get isFakta => verdict == 'FAKTA';

  /// Check apakah verdict adalah RAGU-RAGU
  bool get isRaguRagu => verdict == 'RAGU-RAGU';

  /// Check apakah verdict adalah HOAX
  bool get isHoax => verdict == 'HOAX';

  /// Get confidence level text
  String get confidenceText {
    if (confidence >= 80) return 'Sangat Yakin';
    if (confidence >= 60) return 'Yakin';
    if (confidence >= 40) return 'Cukup Yakin';
    return 'Kurang Yakin';
  }

  /// Get confidence level color
  String get confidenceColor {
    if (confidence >= 80) return '#10B981'; // Green
    if (confidence >= 60) return '#3B82F6'; // Blue
    if (confidence >= 40) return '#F59E0B'; // Yellow
    return '#EF4444'; // Red
  }

  /// === TO JSON METHOD ===
  Map<String, dynamic> toJson() {
    return {
      'verdict': verdict,
      'confidence': confidence,
      'reasoning': reasoning,
      'recommendation': recommendation,
    };
  }

  /// === TO STRING OVERRIDE ===
  @override
  String toString() {
    return 'AccuracyScore(verdict: $verdict, confidence: $confidence%)';
  }
}
