import 'package:flutter/material.dart';
import '../data/models/sharing_preferences.dart';
import '../theme/app_theme.dart';

class PrivacyCard extends StatelessWidget {
  final String residentName;
  final SharingPreferences preferences;

  const PrivacyCard({
    super.key,
    required this.residentName,
    required this.preferences,
  });

  @override
  Widget build(BuildContext context) {
    // Build the first-name for a friendlier label
    final firstName = residentName.split(' ').first;

    final items = <_PrivacyItem>[
      _PrivacyItem(
        label: 'Medication',
        shared: preferences.shareMedicationStatus,
      ),
      _PrivacyItem(
        label: 'Meals',
        shared: preferences.shareMealStatus,
      ),
      _PrivacyItem(
        label: 'Activities',
        shared: preferences.shareActivityDetails,
      ),
      _PrivacyItem(
        label: 'Vitals',
        shared: preferences.shareVitalDetails,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: AppTheme.borderSubtle, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                const Icon(
                  Icons.shield_outlined,
                  color: AppTheme.primary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Privacy & sharing',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '$firstName chooses what is shared with family.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 16),

            // Privacy items — compact rows
            ...items.map((item) => _buildRow(context, item)),

            // Subtle agency footer
            const SizedBox(height: 8),
            Container(
              height: 1,
              color: AppTheme.borderSubtle,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 11,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Shared with you by $firstName',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, _PrivacyItem item) {
    final chipBg   = item.shared ? AppTheme.privacyShared : AppTheme.privacyPrivate;
    final chipText = item.shared ? AppTheme.privacySharedText : AppTheme.privacyPrivateText;
    final label    = item.shared ? 'Shared' : 'Private';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: chipBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: chipText,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacyItem {
  final String label;
  final bool shared;
  const _PrivacyItem({required this.label, required this.shared});
}
