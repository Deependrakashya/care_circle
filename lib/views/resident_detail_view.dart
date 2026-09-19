import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/care_event.dart';
import '../data/models/resident.dart';
import '../data/models/sharing_preferences.dart';
import '../data/models/visibility.dart' as v;
import '../data/models/vital_reading.dart';
import '../view_models/resident_detail_view_model.dart';
import 'check_in_view.dart';
import 'timeline_view.dart';
import '../widgets/resident_header.dart';
import '../widgets/reassurance_card.dart';
import '../widgets/event_card.dart';
import '../widgets/vital_card.dart';
import '../widgets/staff_update_card.dart';
import '../widgets/privacy_card.dart';

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

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ResidentDetailViewModel>();
    final resident = viewModel.resident;

    return Scaffold(
      appBar: AppBar(
        title: const Text(''), // Replaced by header
        scrolledUnderElevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          viewModel.loadAll();
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          children: [
            ResidentHeader(
              initials: resident.avatarInitials,
              name: resident.name,
              relationship: resident.relationship,
              facilityName: '${resident.facility.name}, ${resident.facility.city}',
              showChevron: false,
            ),
            const SizedBox(height: 24),
            _buildSummarySection(context, viewModel),
            const SizedBox(height: 28),
            _buildEventsSection(context, viewModel),
            const SizedBox(height: 28),
            _buildVitalsSection(context, viewModel),
            const SizedBox(height: 28),
            _buildStaffUpdatesSection(context, viewModel),
            const SizedBox(height: 28),
            PrivacyCard(residentName: resident.name, preferences: resident.sharingPreferences),
            const SizedBox(height: 28),
            _buildActions(context, resident),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context, ResidentDetailViewModel viewModel) {
    if (viewModel.summary.status == SectionStatus.loading || viewModel.summary.status == SectionStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (viewModel.summary.status == SectionStatus.error) {
       return Text(viewModel.summary.errorMessage ?? 'Error loading summary', style: TextStyle(color: Theme.of(context).colorScheme.error));
    }

    final summary = viewModel.summary.data;
    if (summary == null) {
      return ReassuranceCard(
        headline: 'Not enough information yet',
        explanation: 'Only a few updates have been recorded today.',
        lastUpdated: DateTime.now(),
        isInsufficientData: true,
        onRequestCheckIn: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CheckInView(resident: viewModel.resident),
            ),
          );
        },
      );
    }

    final now = DateTime.now().toUtc();
    final generatedAt = summary.generatedAt;
    final isStale = now.difference(generatedAt).inHours > 24 || now.day != generatedAt.day;

    return ReassuranceCard(
      headline: summary.headline,
      explanation: summary.highlights.isNotEmpty ? summary.highlights.first : null,
      lastUpdated: summary.generatedAt,
      isInsufficientData: isStale,
      onRequestCheckIn: isStale ? () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CheckInView(resident: viewModel.resident),
            ),
          );
      } : null,
    );
  }

  Widget _buildEventsSection(BuildContext context, ResidentDetailViewModel viewModel) {
    if (viewModel.events.status == SectionStatus.loading || viewModel.events.status == SectionStatus.initial) {
      return const SizedBox.shrink();
    }
    
    final events = viewModel.events.data ?? [];
    if (events.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's moments",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ...events.take(3).map(_buildEventItem),
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
          subtitle: event.durationMinutes != null ? '${event.durationMinutes} min' : null,
          note: event.note,
          icon: Icons.directions_walk_outlined,
          isDelayed: event.status.name == 'delayed',
        );
    }
  }

  Widget _buildVitalsSection(BuildContext context, ResidentDetailViewModel viewModel) {
    if (!viewModel.resident.sharingPreferences.shareVitalDetails) {
       return Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
            Text('Vitals', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            VitalCard(vital: VitalReading(id: '', residentId: '', type: VitalType.heartRate, value: '0', unit: '', measuredAt: DateTime.now(), visibility: v.Visibility.residentOnly), isPrivate: true),
         ]
       );
    }

    if (viewModel.vitals.status == SectionStatus.loading || viewModel.vitals.status == SectionStatus.initial) {
      return const SizedBox.shrink();
    }

    final vitals = viewModel.vitals.data ?? [];
    if (vitals.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vitals',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ...vitals.map((v) => VitalCard(vital: v, isPrivate: false)),
      ],
    );
  }

  Widget _buildStaffUpdatesSection(BuildContext context, ResidentDetailViewModel viewModel) {
     if (viewModel.resident.sharingPreferences.shareStaffNotes == StaffNoteSharing.none) {
        return const SizedBox.shrink();
     }

     if (viewModel.staffUpdates.status == SectionStatus.loading || viewModel.staffUpdates.status == SectionStatus.initial) {
      return const SizedBox.shrink();
    }

    final updates = viewModel.staffUpdates.data ?? [];
    if (updates.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Staff updates',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ...updates.map((u) => StaffUpdateCard(
          authorRole: u.authorRole,
          text: u.text,
          mediaUrl: u.mediaUrl,
          time: u.createdAt,
          sharePhotos: viewModel.resident.sharingPreferences.sharePhotos,
        )),
      ],
    );
  }

  Widget _buildActions(BuildContext context, Resident resident) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TimelineView(resident: resident),
              ),
            );
          },
          child: const Text('See all updates'),
        ),
        const SizedBox(height: 24),
        Text(
          'Need another update?',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CheckInView(resident: resident),
              ),
            );
          },
          child: const Text('Request a check-in'),
        ),
      ],
    );
  }

  String _capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : s;
}
