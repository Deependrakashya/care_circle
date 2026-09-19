import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import 'status_chip.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String status;
  final DateTime time;
  final String? subtitle;
  final String? note;
  final IconData icon;
  final bool isDelayed;

  const EventCard({
    super.key,
    required this.title,
    required this.status,
    required this.time,
    this.subtitle,
    this.note,
    required this.icon,
    this.isDelayed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isDelayed ? AppTheme.privacyLimited : AppTheme.surface,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDelayed ? AppTheme.surface.withValues(alpha: 0.5) : AppTheme.background,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isDelayed ? AppTheme.semanticCaution : AppTheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat.jm().format(time.toLocal()),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      StatusChip(
                        label: status,
                        type: isDelayed ? ChipType.caution : ChipType.neutral,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(width: 12),
                        Text(
                          subtitle!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ],
                  ),
                  if (note != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      note!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
