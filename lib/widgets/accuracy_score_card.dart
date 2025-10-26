import 'package:flutter/material.dart';
import '../models/accuracy_score.dart';
import '../theme/app_theme.dart';

/// Widget untuk menampilkan Accuracy Score Card
/// Menampilkan verdict (FAKTA/RAGU-RAGU/HOAX) dengan confidence level
class AccuracyScoreCard extends StatelessWidget {
  final AccuracyScore score;

  const AccuracyScoreCard({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final verdictColor = _getVerdictBgColor();
    final verdictIcon = score.verdictIcon;
    final verdict = score.verdict;
    final confidence = score.confidence;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Large Verdict Badge
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: verdictColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: verdictColor.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              // Large Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: verdictColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: Text(
                  verdictIcon,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Verdict Text
              Text(
                verdict,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: verdictColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),

              // Confidence
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Confidence: ',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.subduedGray,
                    ),
                  ),
                  Text(
                    '$confidence%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: verdictColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Confidence Bar
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: confidence / 100,
                  minHeight: 6,
                  backgroundColor: AppTheme.surfaceElevated,
                  valueColor: AlwaysStoppedAnimation<Color>(verdictColor),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Reasoning
        Text(
          'Penjelasan:',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          score.reasoning,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.subduedGray,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),

        // Recommendation
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: verdictColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: verdictColor.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: verdictColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  score.recommendation,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.subduedGray,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getVerdictBgColor() {
    switch (score.verdict) {
      case 'FAKTA':
        return const Color(0xFF10B981); // Green
      case 'RAGU-RAGU':
        return const Color(0xFFF59E0B); // Yellow
      case 'HOAX':
        return const Color(0xFFEF4444); // Red
      default:
        return Colors.grey;
    }
  }
}
