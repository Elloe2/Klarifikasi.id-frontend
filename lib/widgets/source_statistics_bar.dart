import 'package:flutter/material.dart';
import '../models/source_statistics.dart';
import '../theme/app_theme.dart';

/// Widget untuk menampilkan Source Statistics Bar
/// Menampilkan progress bar dengan warna dan legend
class SourceStatisticsBar extends StatelessWidget {
  final SourceStatistics stats;

  const SourceStatisticsBar({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    if (!stats.isValid) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              // Support (Green)
              if (stats.supportCount > 0)
                Expanded(
                  flex: stats.supportCount,
                  child: Container(
                    height: 40,
                    color: const Color(0xFF10B981),
                    alignment: Alignment.center,
                    child: Text(
                      '${stats.supportCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              // Neutral (Yellow)
              if (stats.neutralCount > 0)
                Expanded(
                  flex: stats.neutralCount,
                  child: Container(
                    height: 40,
                    color: const Color(0xFFF59E0B),
                    alignment: Alignment.center,
                    child: Text(
                      '${stats.neutralCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              // Oppose (Red)
              if (stats.opposeCount > 0)
                Expanded(
                  flex: stats.opposeCount,
                  child: Container(
                    height: 40,
                    color: const Color(0xFFEF4444),
                    alignment: Alignment.center,
                    child: Text(
                      '${stats.opposeCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Legend
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _LegendItem(
              color: const Color(0xFF10B981),
              label: 'Mendukung',
              count: stats.supportCount,
              percentage: stats.supportPercentageStr,
            ),
            _LegendItem(
              color: const Color(0xFFF59E0B),
              label: 'Netral',
              count: stats.neutralCount,
              percentage: stats.neutralPercentageStr,
            ),
            _LegendItem(
              color: const Color(0xFFEF4444),
              label: 'Tidak Mendukung',
              count: stats.opposeCount,
              percentage: stats.opposePercentageStr,
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Total Sources
        Text(
          'Total: ${stats.totalSources} sumber',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.mutedGray,
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int count;
  final String percentage;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.count,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$label $count ($percentage%)',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.subduedGray,
          ),
        ),
      ],
    );
  }
}
