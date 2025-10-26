import 'package:flutter/material.dart';
import '../models/gemini_analysis.dart';
import '../theme/app_theme.dart';
import 'gemini_logo.dart';
import 'accuracy_score_card.dart';
import 'source_statistics_bar.dart';
import 'source_details_list.dart';

/// Widget untuk menampilkan analisis Gemini AI
/// Meng-handle berbagai state: loading, kosong, error, dan sukses.
class GeminiChatbot extends StatelessWidget {
  final GeminiAnalysis? analysis;
  final bool isLoading;
  final VoidCallback? onRetry;

  const GeminiChatbot({
    super.key,
    this.analysis,
    this.isLoading = false,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppTheme.surfaceElevated,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan icon Gemini
            Row(
              children: [
                const GeminiLogo(size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Fact-Checker',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                      ),
                      Text(
                        'Powered by Gemini AI',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.subduedGray,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onRetry != null && analysis != null && !analysis!.success)
                  IconButton(
                    onPressed: onRetry,
                    icon: const Icon(
                      Icons.refresh,
                      color: AppTheme.primarySeedColor,
                      size: 20,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Content berdasarkan status
            if (isLoading) ...[
              _buildLoadingState(context),
            ] else if (analysis == null) ...[
              _buildEmptyState(context),
            ] else if (!analysis!.success) ...[
              _buildErrorState(context),
            ] else ...[
              _buildAnalysisResult(context),
            ],
          ],
        ),
      ),
    );
  }

  /// Tampilan saat Gemini masih memproses analisis klaim
  Widget _buildLoadingState(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.primarySeedColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Menganalisis klaim...',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.subduedGray),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'AI sedang memeriksa kebenaran klaim ini',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppTheme.mutedGray),
        ),
      ],
    );
  }

  /// Tampilan default ketika belum ada analisis yang bisa ditampilkan
  Widget _buildEmptyState(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.psychology_outlined, color: AppTheme.mutedGray, size: 32),
        const SizedBox(height: 8),
        Text(
          'AI Fact-Checker siap menganalisis',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.subduedGray),
        ),
        const SizedBox(height: 4),
        Text(
          'Masukkan klaim untuk mendapatkan analisis AI',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppTheme.mutedGray),
        ),
      ],
    );
  }

  /// Tampilan error ketika analisis gagal atau diblokir
  Widget _buildErrorState(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.error_outline,
          color: Colors.red.withValues(alpha: 0.7),
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          'Gagal menganalisis klaim',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.red.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          analysis?.error ?? 'Terjadi kesalahan saat menganalisis',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppTheme.mutedGray),
        ),
      ],
    );
  }

  /// Tampilan utama ketika analisis sukses dan siap dibaca
  Widget _buildAnalysisResult(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Explanation
        Text(
          'Penjelasan:',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          analysis!.explanation,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.subduedGray,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),

        // Detailed Analysis
        if (analysis!.detailedAnalysis != null &&
            analysis!.detailedAnalysis!.isNotEmpty &&
            analysis!.detailedAnalysis != 'Tidak ada analisis tersedia') ...[
          Text(
            'Analisis Mendalam:',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primarySeedColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.primarySeedColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              analysis!.detailedAnalysis!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.subduedGray,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Enhanced Data: Show accuracy score if available
        if (analysis!.hasEnhancedData) ...[
          // Accuracy Score Card
          AccuracyScoreCard(score: analysis!.accuracyScore!),
          const SizedBox(height: 16),

          // Source Statistics Bar
          SourceStatisticsBar(stats: analysis!.statistics!),
          const SizedBox(height: 16),

          // Source Details List
          SourceDetailsList(sources: analysis!.sourceAnalysis!),
        ],
      ],
    );
  }
}
