import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/care_event.dart';
import '../theme/app_theme.dart';
import '../view_models/resident_detail_view_model.dart';
import '../widgets/resident_header.dart';
import '../widgets/reassurance_card.dart';
import '../widgets/event_card.dart';
import '../widgets/privacy_card.dart';
import 'resident_picker_sheet.dart';
import 'check_in_sheet.dart';
import 'timeline_view.dart';

class ResidentDetailView extends StatefulWidget {
  const ResidentDetailView({super.key});

  @override
  State<ResidentDetailView> createState() => _ResidentDetailViewState();
}

class _ResidentDetailViewState extends State<ResidentDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ResidentDetailViewModel>().loadAll();
    });
  }

  // ── Contextual greeting based on local time ────────────────────────────────
  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ResidentDetailViewModel>();
    final resident = viewModel.resident;

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        scrolledUnderElevation: 0,
        toolbarHeight: 0, // collapsed — header is inline
      ),
      body: RefreshIndicator(
        color: AppTheme.primary,
        strokeWidth: 2,
        onRefresh: () async => viewModel.loadAll(),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.pagePadding,
                20,
                AppTheme.pagePadding,
                0,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Contextual greeting ────────────────────────────────────
                  Text(
                    _greeting,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textTertiary,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // ── Resident identity header ───────────────────────────────
                  ResidentHeader(
                    initials: resident.avatarInitials,
                    name: resident.name,
                    relationship: resident.relationship,
                    facilityName:
                        '${resident.facility.name}, ${resident.facility.city}',
                    showChevron: true,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => const ResidentPickerSheet(),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // ── Reassurance hero ───────────────────────────────────────
                  _buildSummarySection(context, viewModel),
                  const SizedBox(height: 24),

                  // ── Today's moments ────────────────────────────────────────
                  _buildEventsSection(context, viewModel),

                  // ── Privacy & sharing ──────────────────────────────────────
                  PrivacyCard(
                    residentName: resident.name,
                    preferences: resident.sharingPreferences,
                  ),
                  const SizedBox(height: 24),

                  // ── Check-in CTA ───────────────────────────────────────────
                  _buildCheckInCta(context, viewModel),
                  const SizedBox(height: 36),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Reassurance hero ────────────────────────────────────────────────────────
  Widget _buildSummarySection(
    BuildContext context,
    ResidentDetailViewModel viewModel,
  ) {
    if (viewModel.summary.status == SectionStatus.loading ||
        viewModel.summary.status == SectionStatus.initial) {
      return _ReassuranceSkeleton();
    }

    if (viewModel.summary.status == SectionStatus.error) {
      return _ErrorSurface(
        message:
            'Some information is temporarily unavailable.\nOther CareCircle updates are still available.',
        onRetry: () => viewModel.loadAll(),
      );
    }

    final summary = viewModel.summary.data;
    final latestUpdate =
        viewModel.latestCareUpdate ?? (summary?.generatedAt ?? DateTime.now());

    final now = DateTime.now().toUtc();
    final isStale =
        summary == null ||
        (now.difference(summary.generatedAt).inHours > 24 ||
            now.day != summary.generatedAt.day);

    final firstName = viewModel.resident.name.split(' ').first;

    if (isStale) {
      return ReassuranceCard(
        headline: "There isn't enough information yet.",
        explanation:
            "A few updates have been recorded today, but there isn't enough for a full picture.",
        lastUpdated: latestUpdate,
        isInsufficientData: true,
        // No "Shared with you" cue on insufficient-data state
        onRequestCheckIn: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => CheckInSheet(resident: viewModel.resident),
          );
        },
      );
    }

    return ReassuranceCard(
      headline: summary.headline,
      explanation:
          viewModel.derivedExplanation ??
          (summary.highlights.isNotEmpty ? summary.highlights.first : null),
      lastUpdated: latestUpdate,
      isInsufficientData: false,
      residentFirstName: firstName, // enables "Shared with you by Meera"
    );
  }

  // ─── Events section ───────────────────────────────────────────────────────────
  Widget _buildEventsSection(
    BuildContext context,
    ResidentDetailViewModel viewModel,
  ) {
    if (viewModel.events.status == SectionStatus.loading ||
        viewModel.events.status == SectionStatus.initial) {
      return const SizedBox.shrink();
    }

    final events = viewModel.events.data ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with "See all" link
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Today's moments",

              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (events.isNotEmpty)
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TimelineView(resident: viewModel.resident),
                  ),
                ),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  child: Text(
                    'See all',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        if (events.isEmpty)
          const _EmptyMoments()
        else
          // Staggered entrance for event cards
          ...events.take(3).toList().asMap().entries.map((entry) {
            final idx = entry.key;
            final event = entry.value;
            return _StaggeredEventCard(
              index: idx,
              child: _buildEventItem(event),
            );
          }),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildEventItem(CareEvent event) {
    switch (event) {
      case MedicationEvent():
        return EventCard(
          title: event.medicationLabel,
          status: event.status.name,
          time: event.recordedAt,
          note: event.note,
          icon: Icons.medication_outlined,
          isDelayed: event.status.name == 'delayed',
        );
      case MealEvent():
        return EventCard(
          title: '${_capitalize(event.mealType.name)} meal',
          status: event.status.name,
          time: event.recordedAt,
          note: event.note,
          icon: Icons.restaurant_outlined,
          isDelayed: event.status.name == 'delayed',
        );
      case ActivityEvent():
        return EventCard(
          title: event.activityType,
          status: event.status.name,
          time: event.recordedAt,
          subtitle: event.durationMinutes != null
              ? '${event.durationMinutes} min'
              : null,
          note: event.note,
          icon: Icons.directions_walk_outlined,
          isDelayed: event.status.name == 'delayed',
        );
    }
  }

  // ─── Check-in CTA ─────────────────────────────────────────────────────────────
  Widget _buildCheckInCta(
    BuildContext context,
    ResidentDetailViewModel viewModel,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: AppTheme.borderSubtle, width: 1),
      ),
      padding: const EdgeInsets.all(AppTheme.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Need another update?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          Text(
            'You can request a check-in from the care team.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => CheckInSheet(resident: viewModel.resident),
              );
            },
            child: const Text('Request a check-in'),
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : s;
}

// ─── Staggered card entrance ─────────────────────────────────────────────────
class _StaggeredEventCard extends StatefulWidget {
  final int index;
  final Widget child;
  const _StaggeredEventCard({required this.index, required this.child});

  @override
  State<_StaggeredEventCard> createState() => _StaggeredEventCardState();
}

class _StaggeredEventCardState extends State<_StaggeredEventCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    // Stagger: 60ms per card — feels like the day unfolds
    Future.delayed(Duration(milliseconds: widget.index * 60), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

// ─── Skeleton placeholder ─────────────────────────────────────────────────────
class _ReassuranceSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        color: AppTheme.heroSurface,
        borderRadius: BorderRadius.circular(AppTheme.heroRadius),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Shimmer(width: 44, height: 44, radius: 22),
          const SizedBox(height: 16),
          _Shimmer(width: 220, height: 16, radius: 8),
          const SizedBox(height: 8),
          _Shimmer(width: 160, height: 16, radius: 8),
          const SizedBox(height: 12),
          _Shimmer(width: double.infinity, height: 13, radius: 6),
        ],
      ),
    );
  }
}

class _Shimmer extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  const _Shimmer({
    required this.width,
    required this.height,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ─── Empty moments state ──────────────────────────────────────────────────────
class _EmptyMoments extends StatelessWidget {
  const _EmptyMoments();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: AppTheme.borderSubtle, width: 1),
      ),
      child: Column(
        children: [
          Icon(Icons.wb_sunny_outlined, size: 32, color: AppTheme.textTertiary),
          const SizedBox(height: 10),
          Text(
            'No recent updates yet',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            "CareCircle hasn't recorded a new update\nfor this period.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

// ─── Error surface ────────────────────────────────────────────────────────────
class _ErrorSurface extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  const _ErrorSurface({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.semanticCaution.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(
          color: AppTheme.semanticCaution.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppTheme.semanticCaution,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Temporarily unavailable',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.semanticCaution,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(120, 40),
                side: const BorderSide(
                  color: AppTheme.semanticCaution,
                  width: 1,
                ),
                foregroundColor: AppTheme.semanticCaution,
              ),
              child: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}
