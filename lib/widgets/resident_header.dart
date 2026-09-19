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
    Widget content = Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppTheme.primarySoft,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: const TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  relationship,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  facilityName,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (isSelected)
            const Icon(
              Icons.check_circle,
              color: AppTheme.primary,
            ),
          if (!isSelected && onTap != null && showChevron)
            const Icon(
              Icons.chevron_right,
              color: AppTheme.textSecondary,
            )
        ],
      ),
    );

    if (onTap == null) {
      return content; // Used in details page without card background
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: isSelected
            ? const BorderSide(color: AppTheme.primary, width: 2)
            : const BorderSide(color: AppTheme.border, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: content,
      ),
    );
  }
}
