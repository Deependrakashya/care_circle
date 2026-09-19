import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class ReassuranceCard extends StatelessWidget {
  final String headline;
  final String? explanation;
  final DateTime lastUpdated;
  final bool isInsufficientData;
  final VoidCallback? onRequestCheckIn;

  const ReassuranceCard({
    super.key,
    required this.headline,
    this.explanation,
    required this.lastUpdated,
    this.isInsufficientData = false,
    this.onRequestCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isInsufficientData
        ? const Color(0xFFFAEED8)  // soft warm amber
        : AppTheme.heroSurface;    // soft sage-teal

    final iconBg = isInsufficientData
        ? const Color(0xFFEFD5A4).withValues(alpha: 0.55)
        : AppTheme.primary.withValues(alpha: 0.12);

    final iconColor = isInsufficientData
        ? AppTheme.semanticCaution
        : AppTheme.primary;

    final icon = isInsufficientData
        ? Icons.info_outline_rounded
        : Icons.favorite_border_rounded;

    final headlineColor = isInsufficientData
        ? const Color(0xFF7A5020)
        : AppTheme.textPrimary;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppTheme.heroRadius),
        // Very subtle inner border for tactility
        border: Border.all(
          color: isInsufficientData
              ? const Color(0xFFE8C98A).withValues(alpha: 0.6)
              : AppTheme.primary.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 18),

            // Headline — largest, most important text
            Text(
              headline,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: headlineColor,
                    height: 1.2,
                  ),
            ),

            // Explanation — supporting sentence
            if (explanation != null && explanation!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                explanation!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isInsufficientData
                          ? const Color(0xFF9A6B30)
                          : AppTheme.textSecondary,
                      height: 1.5,
                    ),
              ),
            ],

            const SizedBox(height: 22),

            // Freshness divider
            Container(
              height: 1,
              color: isInsufficientData
                  ? const Color(0xFFE8C98A).withValues(alpha: 0.45)
                  : AppTheme.primary.withValues(alpha: 0.1),
            ),

            const SizedBox(height: 14),

            // Bottom metadata row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 13,
                  color: isInsufficientData
                      ? AppTheme.semanticCaution.withValues(alpha: 0.7)
                      : AppTheme.primary.withValues(alpha: 0.55),
                ),
                const SizedBox(width: 5),
                Text(
                  'Latest CareCircle update · ${DateFormat.jm().format(lastUpdated.toLocal())}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isInsufficientData
                            ? AppTheme.semanticCaution.withValues(alpha: 0.8)
                            : AppTheme.primary.withValues(alpha: 0.65),
                        fontWeight: FontWeight.w500,
                      ),
                ),
                if (isInsufficientData && onRequestCheckIn != null) ...[
                  const Spacer(),
                  GestureDetector(
                    onTap: onRequestCheckIn,
                    child: Text(
                      'Request update',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.semanticCaution,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: AppTheme.semanticCaution.withValues(alpha: 0.5),
                          ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
