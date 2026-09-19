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
    final bgColor = isInsufficientData ? AppTheme.privacyLimited : AppTheme.primarySoft;
    final textColor = isInsufficientData ? AppTheme.privacyLimitedText : AppTheme.primary;
    final iconColor = isInsufficientData ? AppTheme.semanticCaution : AppTheme.primary;
    final icon = isInsufficientData ? Icons.info_outline : Icons.favorite_border;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  headline,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ],
          ),
          if (explanation != null) ...[
            const SizedBox(height: 16),
            Text(
              explanation!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Latest recorded update',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat.jm().format(lastUpdated.toLocal()),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              if (isInsufficientData && onRequestCheckIn != null)
                TextButton(
                  onPressed: onRequestCheckIn,
                  style: TextButton.styleFrom(
                    foregroundColor: textColor,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  child: const Text('Request a check-in'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
