import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/care_event.dart';
import '../data/models/resident.dart';
import '../view_models/resident_detail_view_model.dart';
import '../view_models/timeline_view_model.dart';

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
    
    switch (event) {
      case MedicationEvent():
        title = event.medicationLabel;
        status = event.status.name;
      case MealEvent():
        title = '${event.mealType.name} meal';
        status = event.status.name;
      case ActivityEvent():
        title = event.activityType;
        status = event.status.name;
        if (event.durationMinutes != null) {
          subtitle = '${event.durationMinutes} min';
        }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          timeStr,
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Text(
                _capitalize(title),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Text(
              _capitalize(status),
              style: TextStyle(
                color: status == 'delayed' ? Colors.orange : Colors.grey[700],
              ),
            ),
          ],
        ),
        if (subtitle != null)
          Text(subtitle, style: TextStyle(color: Colors.grey[600])),
        if (event.note != null)
          Text(
            event.note!,
            style: const TextStyle(fontStyle: FontStyle.italic),
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
