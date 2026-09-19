import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

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
    final cardBg = isDelayed
        ? const Color(0xFFFAEED8)
        : AppTheme.surface;

    final iconBg = isDelayed
        ? const Color(0xFFEFD5A4).withValues(alpha: 0.55)
        : AppTheme.primarySoft;

    final iconColor = isDelayed
        ? AppTheme.semanticCaution
        : AppTheme.primary;

    // Build status + time inline label: "Taken · 8:11 AM"
    final timeStr = DateFormat.jm().format(time.toLocal());
    final statusLabel = _capitalize(status);
    final inlineDetail = subtitle != null
        ? '$statusLabel · $timeStr · $subtitle'
        : '$statusLabel · $timeStr';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(
          color: isDelayed
              ? const Color(0xFFE8C98A).withValues(alpha: 0.6)
              : AppTheme.borderSubtle,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container — 42px circle
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    inlineDetail,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDelayed
                              ? AppTheme.semanticCaution.withValues(alpha: 0.85)
                              : AppTheme.textTertiary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  if (note != null && note!.isNotEmpty) ...[
                    const SizedBox(height: 7),
                    Text(
                      note!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

  String _capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : s;
}
