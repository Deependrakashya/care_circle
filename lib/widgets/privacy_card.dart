import 'package:flutter/material.dart';
import '../data/models/sharing_preferences.dart';
import '../theme/app_theme.dart';
import 'status_chip.dart';

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

    ChipType getChipType(bool shared) =>
        shared ? ChipType.privacyShared : ChipType.privacyPrivate;
    String getLabel(bool shared) => shared ? 'Shared' : 'Private';

    ChipType getNotesChipType(StaffNoteSharing sharing) => switch (sharing) {
          StaffNoteSharing.all => ChipType.privacyShared,
          StaffNoteSharing.limited => ChipType.privacyLimited,
          StaffNoteSharing.none => ChipType.privacyPrivate,
        };
    String getNotesLabel(StaffNoteSharing sharing) => switch (sharing) {
          StaffNoteSharing.all => 'Shared',
          StaffNoteSharing.limited => 'Limited',
          StaffNoteSharing.none => 'Private',
        };

    final items = <_PrivacyItem>[
      _PrivacyItem(
        label: 'Medication',
        type: getChipType(preferences.shareMedicationStatus),
        statusLabel: getLabel(preferences.shareMedicationStatus),
      ),
      _PrivacyItem(
        label: 'Meals',
        type: getChipType(preferences.shareMealStatus),
        statusLabel: getLabel(preferences.shareMealStatus),
      ),
      _PrivacyItem(
        label: 'Activities',
        type: getChipType(preferences.shareActivityDetails),
        statusLabel: getLabel(preferences.shareActivityDetails),
      ),
      _PrivacyItem(
        label: 'Vitals',
        type: getChipType(preferences.shareVitalDetails),
        statusLabel: getLabel(preferences.shareVitalDetails),
      ),
      _PrivacyItem(
        label: 'Staff Notes',
        type: getNotesChipType(preferences.shareStaffNotes),
        statusLabel: getNotesLabel(preferences.shareStaffNotes),
      ),
      _PrivacyItem(
        label: 'Photos',
        type: getChipType(preferences.sharePhotos),
        statusLabel: getLabel(preferences.sharePhotos),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: AppTheme.borderSubtle, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
          StatusChip(
            label: item.statusLabel,
            type: item.type,
          ),
        ],
      ),
    );
  }
}

class _PrivacyItem {
  final String label;
  final ChipType type;
  final String statusLabel;

  const _PrivacyItem({
    required this.label,
    required this.type,
    required this.statusLabel,
  });
}
