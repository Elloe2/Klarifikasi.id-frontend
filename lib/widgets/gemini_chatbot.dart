import 'package:flutter/material.dart';
import '../models/gemini_analysis.dart';
import '../theme/app_theme.dart';

/// Widget untuk menampilkan analisis Gemini AI
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 0,
        color: AppTheme.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan icon Gemini
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.psychology,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Fact-Checker',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
      ),
    );
  }

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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.subduedGray,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'AI sedang memeriksa kebenaran klaim ini',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.mutedGray,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.psychology_outlined,
          color: AppTheme.mutedGray,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          'AI Fact-Checker siap menganalisis',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.subduedGray,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Masukkan klaim untuk mendapatkan analisis AI',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.mutedGray,
          ),
        ),
      ],
    );
  }

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
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.mutedGray,
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisResult(BuildContext context) {
    final isFact = analysis!.isFact;
    final confidence = analysis!.confidence;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Verdict dengan badge
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isFact 
                    ? Colors.green.withValues(alpha: 0.2)
                    : Colors.red.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isFact ? Colors.green : Colors.red,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isFact ? Icons.check_circle : Icons.cancel,
                    color: isFact ? Colors.green : Colors.red,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    analysis!.verdict,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isFact ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getConfidenceColor(confidence).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Confidence: $confidence',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _getConfidenceColor(confidence),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Explanation
        Text(
          'Penjelasan:',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          analysis!.explanation,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.subduedGray,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 12),

        // Sources
        if (analysis!.sources.isNotEmpty) ...[
          Text(
            'Sumber:',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            analysis!.sources,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.mutedGray,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Color _getConfidenceColor(String confidence) {
    switch (confidence.toLowerCase()) {
      case 'tinggi':
        return Colors.green;
      case 'sedang':
        return Colors.orange;
      case 'rendah':
        return Colors.red;
      default:
        return AppTheme.subduedGray;
    }
  }
}
