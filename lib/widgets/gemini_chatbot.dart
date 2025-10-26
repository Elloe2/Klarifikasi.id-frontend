import 'package:flutter/material.dart';
import '../models/gemini_analysis.dart';
import '../theme/app_theme.dart';
import 'gemini_logo.dart';
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
        _buildVerdictHeader(context),
        const SizedBox(height: 16),

        _buildSupportSummary(context),
        const SizedBox(height: 16),

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

        // Analysis (baru)
        if (analysis!.analysis.isNotEmpty &&
            analysis!.analysis != 'Tidak ada analisis tersedia') ...[
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
              analysis!.analysis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.subduedGray,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        if (analysis!.verdictReason.isNotEmpty) ...[
          Text(
            'Alasan Verdict:',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            analysis!.verdictReason,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.subduedGray,
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 16),
        ],

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
          const SizedBox(height: 16),
        ],

        SourceDetailsList(sources: analysis!.sourceBreakdown),
      ],
    );
  }

  Widget _buildVerdictHeader(BuildContext context) {
    final label = analysis!.verdictLabel;
    final color = _mapVerdictToColor(label);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
      ),
      child: Row(
        children: [
          Icon(
            _mapVerdictToIcon(label),
            color: color,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verdict: $label',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: (analysis!.verdictScore.clamp(0, 100)) / 100,
                  backgroundColor: AppTheme.surfaceElevated.withValues(alpha: 0.4),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${analysis!.verdictScore.toStringAsFixed(0)}%',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSummary(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    Widget buildBadge(String label, int value, Color color) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.labelSmall?.copyWith(
                      color: color.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value.toString(),
                style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ringkasan Sumber',
          style: textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            buildBadge('Mendukung', analysis!.supportingSources, const Color(0xFF10B981)),
            const SizedBox(width: 12),
            buildBadge('Tidak Mendukung', analysis!.nonSupportingSources, const Color(0xFFEF4444)),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Total sumber dianalisis: ${analysis!.totalSources}',
          style: textTheme.bodySmall?.copyWith(color: AppTheme.subduedGray),
        ),
      ],
    );
  }

  IconData _mapVerdictToIcon(String label) {
    switch (label) {
      case 'FAKTA':
        return Icons.verified;
      case 'HOAX':
        return Icons.warning_rounded;
      default:
        return Icons.help_outline;
    }
  }

  Color _mapVerdictToColor(String label) {
    switch (label) {
      case 'FAKTA':
        return const Color(0xFF10B981);
      case 'HOAX':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFFF59E0B);
    }
  }
}
