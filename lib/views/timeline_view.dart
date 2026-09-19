import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/care_event.dart';
import '../data/models/resident.dart';
import '../view_models/resident_detail_view_model.dart';
import '../view_models/timeline_view_model.dart';
import '../theme/app_theme.dart';
import '../widgets/status_chip.dart';

class TimelineView extends StatelessWidget {
  const TimelineView({super.key, required this.resident});

  final Resident resident;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TimelineViewModel(
        resident: resident,
        eventRepository: context.read(),
      )..loadTimeline(),
      child: const _TimelineContent(),
    );
  }
}

class _TimelineContent extends StatelessWidget {
  const _TimelineContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TimelineViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('All updates'),
      ),
      body: _buildBody(context, viewModel),
    );
  }

  Widget _buildBody(BuildContext context, TimelineViewModel viewModel) {
    final state = viewModel.timeline;
    
    switch (state.status) {
      case SectionStatus.initial:
      case SectionStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case SectionStatus.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(state.errorMessage ?? 'An error occurred'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: viewModel.loadTimeline,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      case SectionStatus.ready:
        final events = state.data!;
        if (events.isEmpty) {
          return const Center(child: Text('No updates recorded.'));
        }
        
        return RefreshIndicator(
          onRefresh: viewModel.loadTimeline,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildTimelineItem(context, event),
              );
            },
          ),
        );
    }
  }

  Widget _buildTimelineItem(BuildContext context, CareEvent event) {
    final timeStr = _formatTime(event.recordedAt);
    
    String title;
    String status;
    String? subtitle;
    IconData icon;
    
    switch (event) {
      case MedicationEvent():
        title = event.medicationLabel;
        status = event.status.name;
        icon = Icons.medication_outlined;
      case MealEvent():
        title = '${event.mealType.name} meal';
        status = event.status.name;
        icon = Icons.restaurant_outlined;
      case ActivityEvent():
        title = event.activityType;
        status = event.status.name;
        icon = Icons.directions_walk_outlined;
        if (event.durationMinutes != null) {
          subtitle = '${event.durationMinutes} min';
        }
    }

    final isDelayed = status == 'delayed';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            const SizedBox(height: 4),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isDelayed ? AppTheme.semanticCaution : AppTheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            // A simple line could go here for a full timeline, but for simplicity we keep it clean.
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                timeStr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _capitalize(title),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (subtitle != null)
                          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                        if (event.note != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            event.note!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusChip(
                    label: _capitalize(status),
                    type: isDelayed ? ChipType.caution : ChipType.neutral,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final local = time.toLocal();
    final hour = local.hour > 12 ? local.hour - 12 : (local.hour == 0 ? 12 : local.hour);
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : s;
}
