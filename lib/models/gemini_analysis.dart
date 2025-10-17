/// Model untuk data analisis Gemini AI
class GeminiAnalysis {
  final bool success;
  final String explanation;
  final String sources;
  final String claim;
  final String? error;

  const GeminiAnalysis({
    required this.success,
    required this.explanation,
    required this.sources,
    required this.claim,
    this.error,
  });

  factory GeminiAnalysis.fromJson(Map<String, dynamic> json) {
    return GeminiAnalysis(
      success: json['success'] ?? false,
      explanation: json['explanation'] ?? 'Tidak ada penjelasan tersedia',
      sources: json['sources'] ?? 'Tidak ada sumber tersedia',
      claim: json['claim'] ?? '',
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'explanation': explanation,
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
}
