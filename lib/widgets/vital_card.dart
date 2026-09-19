import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models/vital_reading.dart';
import '../theme/app_theme.dart';

class VitalCard extends StatelessWidget {
  final VitalReading vital;
  final bool isPrivate;

  const VitalCard({
    super.key,
    required this.vital,
    this.isPrivate = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isPrivate) {
      return Card(
        color: AppTheme.privacyPrivate,
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.lock_outline, color: AppTheme.privacyPrivateText),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatVitalType(vital.type),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.privacyPrivateText,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Detailed vital readings are not shared with family.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: AppTheme.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.monitor_heart_outlined,
                color: AppTheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatVitalType(vital.type),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        vital.value.toString(),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        vital.unit,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              'Measured\n${DateFormat.jm().format(vital.measuredAt.toLocal())}',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  String _formatVitalType(VitalType type) {
    return switch (type) {
      VitalType.bloodPressure => 'Blood pressure',
      VitalType.heartRate => 'Heart rate',
      VitalType.bloodGlucose => 'Blood glucose',
    };
  }
}
