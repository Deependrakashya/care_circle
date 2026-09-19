import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum ChipType {
  neutral,
  positive,
  caution,
  privacyShared,
  privacyLimited,
  privacyPrivate,
}

class StatusChip extends StatelessWidget {
  final String label;
  final ChipType type;

  const StatusChip({
    super.key,
    required this.label,
    this.type = ChipType.neutral,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (type) {
      case ChipType.positive:
        bgColor = AppTheme.primarySoft;
        textColor = AppTheme.primary;
        break;
      case ChipType.caution:
        bgColor = AppTheme.semanticCaution.withValues(alpha: 0.15);
        textColor = AppTheme.semanticCaution;
        break;
      case ChipType.privacyShared:
        bgColor = AppTheme.privacyShared;
        textColor = AppTheme.privacySharedText;
        break;
      case ChipType.privacyLimited:
        bgColor = AppTheme.privacyLimited;
        textColor = AppTheme.privacyLimitedText;
        break;
      case ChipType.privacyPrivate:
        bgColor = AppTheme.privacyPrivate;
        textColor = AppTheme.privacyPrivateText;
        break;
      case ChipType.neutral:
        bgColor = AppTheme.background;
        textColor = AppTheme.textSecondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16), // Pill shape
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor,
            ),
      ),
    );
  }
}
