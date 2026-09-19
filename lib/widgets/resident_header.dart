import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ResidentHeader extends StatelessWidget {
  final String initials;
  final String name;
  final String relationship;
  final String facilityName;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool showChevron;

  const ResidentHeader({
    super.key,
    required this.initials,
    required this.name,
    required this.relationship,
    required this.facilityName,
    this.onTap,
    this.isSelected = false,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    // Compact identity row — used both inline (Home) and in the picker sheet
    Widget row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primary.withValues(alpha: 0.15)
                : AppTheme.primarySoft,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: TextStyle(
              color: AppTheme.primary,
              fontWeight: FontWeight.w700,
              fontSize: 18,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(width: 14),

        // Text block
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.headlineSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                relationship,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 1),
              Text(
                facilityName,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // Trailing indicator
        if (isSelected)
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: AppTheme.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 15),
          )
        else if (showChevron && onTap != null)
          const Icon(
            Icons.chevron_right_rounded,
            color: AppTheme.textTertiary,
            size: 22,
          ),
      ],
    );

    // ── Inline header (no card wrapper) — used on Home screen ───────────────
    if (!isSelected && onTap != null && showChevron) {
      // Wrap in tappable surface with very subtle border
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: row,
          ),
        ),
      );
    }

    // ── Picker card — used inside resident picker sheet ──────────────────────
    if (onTap != null) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primarySoft : AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          border: Border.all(
            color: isSelected
                ? AppTheme.primary.withValues(alpha: 0.3)
                : AppTheme.borderSubtle,
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: row,
            ),
          ),
        ),
      );
    }

    // ── Static (no interaction) ──────────────────────────────────────────────
    return row;
  }
}
