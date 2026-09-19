import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/care_event.dart';
import '../data/models/resident.dart';
import '../data/models/sharing_preferences.dart';
import '../data/models/vital_reading.dart';
import '../view_models/resident_detail_view_model.dart';
import 'check_in_view.dart';
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
    // Schedule loading after the widget is built
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
        title: Text(resident.name),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          viewModel.loadAll();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHeader(context, resident),
            const SizedBox(height: 24),
            _buildSummarySection(context, viewModel),
            const SizedBox(height: 24),
            _buildEventsSection(context, viewModel),
            const SizedBox(height: 24),
            if (resident.sharingPreferences.shareVitalDetails) ...[
              _buildVitalsSection(context, viewModel),
              const SizedBox(height: 24),
            ],
            if (resident.sharingPreferences.shareStaffNotes != StaffNoteSharing.none) ...[
              _buildStaffUpdatesSection(context, viewModel),
              const SizedBox(height: 24),
            ],
            _buildPrivacySection(context, resident),
            const SizedBox(height: 24),
            _buildActions(context, resident),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Resident resident) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          resident.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          '${resident.relationship} • ${resident.facility.name}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[700],
              ),
        ),
      ],
    );
  }

  Widget _buildSummarySection(
      BuildContext context, ResidentDetailViewModel viewModel) {
    return _SectionContainer(
      title: 'Today',
      state: viewModel.summary,
      onRetry: viewModel.loadSummary,
      builder: (context, summary) {
        if (summary == null) {
          return const Text('No summary available yet.');
        }

        final now = DateTime.now().toUtc();
        final generatedAt = summary.generatedAt;
        final isStale =
            now.difference(generatedAt).inHours > 24 || now.day != generatedAt.day;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              summary.headline,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            if (isStale)
              Text(
                'Latest summary is from yesterday',
                style: TextStyle(color: Colors.orange[800]),
              )
            else
              Text(
                'Latest update: _formatTime(generatedAt)', // Simple representation
                style: TextStyle(color: Colors.grey[600]),
              ),
            if (summary.highlights.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...summary.highlights.map((h) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('✓ ', style: TextStyle(color: Colors.green)),
                      Expanded(child: Text(h)),
                    ],
                  )),
            ],
          ],
        );
      },
    );
  }

  Widget _buildEventsSection(
      BuildContext context, ResidentDetailViewModel viewModel) {
    return _SectionContainer(
      title: "Today's moments",
      state: viewModel.events,
      onRetry: viewModel.loadEvents,
      builder: (context, events) {
        if (events.isEmpty) {
          return const Text('No recent updates recorded.');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: events.take(3).map((event) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _buildEventItem(event),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildEventItem(CareEvent event) {
    switch (event) {
      case MedicationEvent():
        return _StatusRow(
          title: event.medicationLabel,
          status: event.status.name,
          note: event.note,
        );
      case MealEvent():
        return _StatusRow(
          title: '${event.mealType.name} meal',
          status: event.status.name,
          note: event.note,
        );
      case ActivityEvent():
        return _StatusRow(
          title: event.activityType,
          status: event.status.name,
          subtitle: event.durationMinutes != null
              ? '${event.durationMinutes} min'
              : null,
          note: event.note,
        );
    }
  }

  Widget _buildVitalsSection(
      BuildContext context, ResidentDetailViewModel viewModel) {
    return _SectionContainer(
      title: 'Vitals',
      state: viewModel.vitals,
      onRetry: viewModel.loadVitals,
      builder: (context, vitals) {
        if (vitals.isEmpty) {
          return const Text('No recent vitals recorded.');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: vitals.map((v) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatVitalType(v.type),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${v.value} ${v.unit}'),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildStaffUpdatesSection(
      BuildContext context, ResidentDetailViewModel viewModel) {
    return _SectionContainer(
      title: 'Staff updates',
      state: viewModel.staffUpdates,
      onRetry: viewModel.loadStaffUpdates,
      builder: (context, updates) {
        if (updates.isEmpty) {
          return const Text('No staff updates today.');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: updates.map((u) {
            final sharePhotos =
                viewModel.resident.sharingPreferences.sharePhotos;
            return Card(
              margin: const EdgeInsets.only(bottom: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      u.authorRole,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (u.text != null) Text(u.text!),
                    if (sharePhotos && u.mediaUrl != null) ...[
                      const SizedBox(height: 8),
                      // Simplified broken image handling
                      Container(
                        height: 100,
                        width: double.infinity,
                        color: Colors.grey[300],
                        alignment: Alignment.center,
                        child: const Text('Photo unavailable'),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildPrivacySection(BuildContext context, Resident resident) {
    final prefs = resident.sharingPreferences;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy & sharing',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('${resident.name} controls what is shared with family.'),
            const SizedBox(height: 12),
            _PrivacyRow('Medication', prefs.shareMedicationStatus ? 'Shared' : 'Private'),
            _PrivacyRow('Meals', prefs.shareMealStatus ? 'Shared' : 'Private'),
            _PrivacyRow('Activities', prefs.shareActivityDetails ? 'Shared' : 'Private'),
            _PrivacyRow('Vitals', prefs.shareVitalDetails ? 'Shared' : 'Private'),
            _PrivacyRow('Photos', prefs.sharePhotos ? 'Shared' : 'Private'),
            _PrivacyRow('Staff notes', _capitalize(prefs.shareStaffNotes.name)),
          ],
        ),
      ),
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
        const SizedBox(height: 12),
        Text(
          'Need another update?',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
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

  String _formatVitalType(VitalType type) {
    return switch (type) {
      VitalType.bloodPressure => 'Blood pressure',
      VitalType.heartRate => 'Heart rate',
      VitalType.bloodGlucose => 'Blood glucose',
    };
  }

  String _capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : s;
}

class _SectionContainer<T> extends StatelessWidget {
  const _SectionContainer({
    required this.title,
    required this.state,
    required this.onRetry,
    required this.builder,
  });

  final String title;
  final SectionState<T> state;
  final VoidCallback onRetry;
  final Widget Function(BuildContext, T) builder;

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (state.status) {
      case SectionStatus.initial:
      case SectionStatus.loading:
        content = const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
        );
      case SectionStatus.error:
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.errorMessage ?? 'An error occurred',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        );
      case SectionStatus.ready:
        content = builder(context, state.data as T);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.title,
    required this.status,
    this.subtitle,
    this.note,
  });

  final String title;
  final String status;
  final String? subtitle;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
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
        if (subtitle != null) Text(subtitle!, style: TextStyle(color: Colors.grey[600])),
        if (note != null)
          Text(
            note!,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
      ],
    );
  }

  String _capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : s;
}

class _PrivacyRow extends StatelessWidget {
  const _PrivacyRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
