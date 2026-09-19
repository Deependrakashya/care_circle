import 'package:flutter/foundation.dart';

import '../data/api/mock_api_error.dart';
import '../data/models/care_event.dart';
import '../data/models/daily_summary.dart';
import '../data/models/resident.dart';
import '../data/models/sharing_preferences.dart';
import '../data/models/staff_update.dart';
import '../data/models/visibility.dart';
import '../data/models/vital_reading.dart';
import '../data/repositories/care_event_repository.dart';
import '../data/repositories/daily_summary_repository.dart';
import '../data/repositories/staff_update_repository.dart';
import '../data/repositories/vital_repository.dart';

enum SectionStatus { initial, loading, ready, error }

class SectionState<T> {
  const SectionState({
    this.status = SectionStatus.initial,
    this.data,
    this.errorMessage,
  });

  final SectionStatus status;
  final T? data;
  final String? errorMessage;

  SectionState<T> copyWith({
    SectionStatus? status,
    T? data,
    String? errorMessage,
  }) {
    return SectionState<T>(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ResidentDetailViewModel extends ChangeNotifier {
  ResidentDetailViewModel({
    required this.resident,
    required DailySummaryRepository summaryRepository,
    required CareEventRepository eventRepository,
    required VitalRepository vitalRepository,
    required StaffUpdateRepository staffUpdateRepository,
  })  : _summaryRepo = summaryRepository,
        _eventRepo = eventRepository,
        _vitalRepo = vitalRepository,
        _staffRepo = staffUpdateRepository;

  final Resident resident;
  final DailySummaryRepository _summaryRepo;
  final CareEventRepository _eventRepo;
  final VitalRepository _vitalRepo;
  final StaffUpdateRepository _staffRepo;

  SectionState<DailySummary?> _summary = const SectionState();
  SectionState<List<CareEvent>> _events = const SectionState();
  SectionState<List<CareEvent>> _timeline = const SectionState();
  SectionState<List<VitalReading>> _vitals = const SectionState();
  SectionState<List<StaffUpdate>> _staffUpdates = const SectionState();

  SectionState<DailySummary?> get summary => _summary;
  SectionState<List<CareEvent>> get events => _events;
  SectionState<List<CareEvent>> get timeline => _timeline;
  SectionState<List<VitalReading>> get vitals => _vitals;
  SectionState<List<StaffUpdate>> get staffUpdates => _staffUpdates;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  String _getSafeErrorMessage(Object error) {
    if (error is MockApiError) {
      return error.message;
    }
    return 'An unexpected error occurred.';
  }

  Future<void> loadSummary() async {
    _summary = _summary.copyWith(status: SectionStatus.loading);
    _notify();
    try {
      final envelope = await _summaryRepo.getDailySummary(resident.id);
      _summary = SectionState(status: SectionStatus.ready, data: envelope.data);
    } catch (e) {
      _summary = SectionState(
        status: SectionStatus.error,
        errorMessage: _getSafeErrorMessage(e),
      );
    }
    _notify();
  }

  Future<void> loadEvents() async {
    _events = _events.copyWith(status: SectionStatus.loading);
    _notify();
    try {
      final envelope = await _eventRepo.listCareEvents(resident.id);
      
      // Privacy filtering: Do not expose resident_only events to family UI
      final familyEvents = envelope.data
          .where((e) => e.visibility != Visibility.residentOnly)
          .toList(growable: false);

      _events = SectionState(status: SectionStatus.ready, data: familyEvents);
    } catch (e) {
      _events = SectionState(
        status: SectionStatus.error,
        errorMessage: _getSafeErrorMessage(e),
      );
    }
    _notify();
  }

  Future<void> loadTimeline() async {
    _timeline = _timeline.copyWith(status: SectionStatus.loading);
    _notify();
    try {
      final envelope = await _eventRepo.listRawTimeline(resident.id);
      
      final familyTimeline = envelope.data
          .where((e) => e.visibility != Visibility.residentOnly)
          .toList(growable: false);

      _timeline = SectionState(status: SectionStatus.ready, data: familyTimeline);
    } catch (e) {
      _timeline = SectionState(
        status: SectionStatus.error,
        errorMessage: _getSafeErrorMessage(e),
      );
    }
    _notify();
  }

  Future<void> loadVitals() async {
    if (!resident.sharingPreferences.shareVitalDetails) {
      _vitals = const SectionState(
        status: SectionStatus.ready,
        data: [], // Empty when not permitted
      );
      _notify();
      return;
    }

    _vitals = _vitals.copyWith(status: SectionStatus.loading);
    _notify();
    try {
      final envelope = await _vitalRepo.listVitals(resident.id);
      
      // Privacy filtering
      final familyVitals = envelope.data
          .where((v) => v.visibility != Visibility.residentOnly)
          .toList(growable: false);

      _vitals = SectionState(status: SectionStatus.ready, data: familyVitals);
    } catch (e) {
      _vitals = SectionState(
        status: SectionStatus.error,
        errorMessage: _getSafeErrorMessage(e),
      );
    }
    _notify();
  }

  Future<void> loadStaffUpdates() async {
    if (resident.sharingPreferences.shareStaffNotes == StaffNoteSharing.none) {
      _staffUpdates = const SectionState(status: SectionStatus.ready, data: []);
      _notify();
      return;
    }

    _staffUpdates = _staffUpdates.copyWith(status: SectionStatus.loading);
    _notify();
    try {
      final envelope = await _staffRepo.listStaffUpdates(resident.id);
      
      // Privacy filtering
      final familyUpdates = envelope.data
          .where((u) => u.visibility != Visibility.residentOnly)
          .where((u) {
            // Limited preference means only 'family' visibility is allowed
            if (resident.sharingPreferences.shareStaffNotes == StaffNoteSharing.limited) {
              return u.visibility == Visibility.family;
            }
            return true;
          })
          .toList(growable: false);

      _staffUpdates = SectionState(status: SectionStatus.ready, data: familyUpdates);
    } catch (e) {
      _staffUpdates = SectionState(
        status: SectionStatus.error,
        errorMessage: _getSafeErrorMessage(e),
      );
    }
    _notify();
  }

  void loadAll() {
    loadSummary();
    loadEvents();
    loadVitals();
    loadStaffUpdates();
    // loadTimeline is loaded separately when navigating to timeline screen
  }
}
