/// Model untuk data analisis Gemini AI
class GeminiAnalysis {
  final bool success;
  final String verdict;
  final String confidence;
  final String explanation;
  final String sources;
  final String claim;
  final String? error;

  const GeminiAnalysis({
    required this.success,
    required this.verdict,
    required this.confidence,
    required this.explanation,
    required this.sources,
    required this.claim,
    this.error,
  });

  factory GeminiAnalysis.fromJson(Map<String, dynamic> json) {
    return GeminiAnalysis(
      success: json['success'] ?? false,
      verdict: json['verdict'] ?? 'HOAX',
      confidence: json['confidence'] ?? 'Rendah',
      explanation: json['explanation'] ?? 'Tidak ada penjelasan tersedia',
      sources: json['sources'] ?? 'Tidak ada sumber tersedia',
      claim: json['claim'] ?? '',
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'verdict': verdict,
      'confidence': confidence,
      'explanation': explanation,
      'sources': sources,
      'claim': claim,
      if (error != null) 'error': error,
    };
  }

  /// Getter untuk menentukan apakah klaim adalah fakta
  bool get isFact => verdict == 'FAKTA';

  /// Getter untuk menentukan apakah klaim adalah hoax
  bool get isHoax => verdict == 'HOAX';

  /// Getter untuk confidence level
  String get confidenceLevel => confidence;

  /// Getter untuk status analisis
  String get status {
    if (!success) return 'Gagal';
    if (isFact) return 'Fakta';
    if (isHoax) return 'Hoax';
    return 'Tidak Diketahui';
  }
}
