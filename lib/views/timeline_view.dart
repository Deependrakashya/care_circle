import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/care_event.dart';
import '../data/models/resident.dart';
import '../view_models/resident_detail_view_model.dart';
import '../view_models/timeline_view_model.dart';
import '../theme/app_theme.dart';

class TimelineView extends StatelessWidget {
  const TimelineView({super.key, required this.resident});

  final Resident resident;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          TimelineViewModel(resident: resident, eventRepository: context.read())
            ..loadTimeline(),
      child: const _TimelineContent(),
    );
  }
}

class _TimelineContent extends StatelessWidget {
  const _TimelineContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TimelineViewModel>();
    final state = viewModel.timeline;

    String title = 'Recent updates';
    if (state.status == SectionStatus.ready &&
        state.data != null &&
        state.data!.isNotEmpty) {
      final now = DateTime.now().toUtc();
      final allToday = state.data!.every(
        (e) =>
            e.recordedAt.day == now.day &&
            e.recordedAt.month == now.month &&
            e.recordedAt.year == now.year,
      );
      if (allToday) title = "Today's moments";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildBody(context, viewModel),
    );
  }

  Widget _buildBody(BuildContext context, TimelineViewModel viewModel) {
    final state = viewModel.timeline;

    switch (state.status) {
      case SectionStatus.initial:
      case SectionStatus.loading:
        return _buildLoadingSkeleton(context);

      case SectionStatus.error:
        return _buildError(context, viewModel);

      case SectionStatus.ready:
        final events = state.data!;
        if (events.isEmpty) return _buildEmpty(context);
        return RefreshIndicator(
          color: AppTheme.primary,
          strokeWidth: 2,
          onRefresh: viewModel.loadTimeline,
          child: _buildTimeline(context, events, viewModel),
        );
    }
  }

  // ─── Timeline list ────────────────────────────────────────────────────────
  Widget _buildTimeline(
    BuildContext context,
    List<CareEvent> events,
    TimelineViewModel vm,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final isLast = index == events.length - 1;
        return _TimelineRow(event: event, isLast: isLast);
      },
    );
  }

  // ─── Loading skeleton ─────────────────────────────────────────────────────
  Widget _buildLoadingSkeleton(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      itemCount: 5,
      itemBuilder: (_, index) => _SkeletonRow(isLast: index == 4),
    );
  }

  // ─── Error state ──────────────────────────────────────────────────────────
  Widget _buildError(BuildContext context, TimelineViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 44,
              color: AppTheme.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'Some information is temporarily unavailable.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Other CareCircle updates are still available.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: viewModel.loadTimeline,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Empty state ──────────────────────────────────────────────────────────
  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wb_sunny_outlined,
              size: 44,
              color: AppTheme.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'No recent updates yet',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 6),
            Text(
              "CareCircle hasn't recorded a new update\nfor this period.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Individual timeline row ─────────────────────────────────────────────────
class _TimelineRow extends StatelessWidget {
  final CareEvent event;
  final bool isLast;

  const _TimelineRow({required this.event, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final isDelayed = _isDelayed(event);
    final dotColor = isDelayed ? AppTheme.semanticCaution : AppTheme.primary;
    final timeStr = _formatTime(event.recordedAt);
    final title = _title(event);
    final detail = _detail(event);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Left: dot + connector ──────────────────────────────────────────
          SizedBox(
            width: 28,
            child: Column(
              children: [
                // Dot
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: dotColor.withValues(alpha: 0.25),
                      width: 3,
                    ),
                  ),
                ),
                // Vertical connector
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.borderSubtle,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // ── Right: content card ────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: isDelayed ? const Color(0xFFFAEED8) : AppTheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  border: Border.all(
                    color: isDelayed
                        ? const Color(0xFFE8C98A).withValues(alpha: 0.55)
                        : AppTheme.borderSubtle,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Time
                    Text(
                      timeStr,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDelayed
                            ? AppTheme.semanticCaution.withValues(alpha: 0.8)
                            : AppTheme.primary.withValues(alpha: 0.65),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Event title
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    // Detail line (status + optional duration)
                    if (detail.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        detail,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDelayed
                              ? AppTheme.semanticCaution.withValues(alpha: 0.85)
                              : AppTheme.textTertiary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    // Optional note
                    if (event.note != null && event.note!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        event.note!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isDelayed(CareEvent e) {
    return switch (e) {
      MedicationEvent() => e.status.name == 'delayed',
      MealEvent() => e.status.name == 'delayed',
      ActivityEvent() => e.status.name == 'delayed',
    };
  }

  String _title(CareEvent e) {
    return switch (e) {
      MedicationEvent() => e.medicationLabel,
      MealEvent() => '${_capitalize(e.mealType.name)} meal',
      ActivityEvent() => e.activityType,
    };
  }

  String _detail(CareEvent e) {
    return switch (e) {
      MedicationEvent() => _capitalize(e.status.name),
      MealEvent() => _capitalize(e.status.name),
      ActivityEvent() =>
        e.durationMinutes != null
            ? '${_capitalize(e.status.name)} · ${e.durationMinutes} min'
            : _capitalize(e.status.name),
    };
  }

  String _formatTime(DateTime time) {
    final local = time.toLocal();
    final hour = local.hour > 12
        ? local.hour - 12
        : (local.hour == 0 ? 12 : local.hour);
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : s;
}

// ─── Skeleton row ────────────────────────────────────────────────────────────
class _SkeletonRow extends StatelessWidget {
  final bool isLast;
  const _SkeletonRow({required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: AppTheme.borderSubtle,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
              child: Container(
                height: 76,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
