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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.shield_outlined, color: AppTheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Privacy & sharing',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '$residentName controls what is shared with family.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
            const SizedBox(height: 24),
            _buildRow('Medication', preferences.shareMedicationStatus ? 'Shared' : 'Private'),
            const Divider(),
            _buildRow('Meals', preferences.shareMealStatus ? 'Shared' : 'Private'),
            const Divider(),
            _buildRow('Activities', preferences.shareActivityDetails ? 'Shared' : 'Private'),
            const Divider(),
            _buildRow('Vitals', preferences.shareVitalDetails ? 'Shared' : 'Private'),
            const Divider(),
            _buildRow('Photos', preferences.sharePhotos ? 'Shared' : 'Private'),
            const Divider(),
            _buildRow('Staff notes', _capitalize(preferences.shareStaffNotes.name)),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    ChipType type;
    switch (value.toLowerCase()) {
      case 'shared':
      case 'full':
        type = ChipType.privacyShared;
        break;
      case 'limited':
      case 'summary':
        type = ChipType.privacyLimited;
        break;
      case 'private':
      case 'none':
      default:
        type = ChipType.privacyPrivate;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          StatusChip(
            label: value == 'summary' ? 'Limited' : _capitalize(value),
            type: type,
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) {
    if (s == 'none') return 'Private';
    return s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : s;
  }
}
