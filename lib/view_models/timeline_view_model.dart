import 'package:flutter/foundation.dart';

import '../data/api/mock_api_error.dart';
import '../data/models/care_event.dart';
import '../data/models/resident.dart';
import '../data/models/visibility.dart';
import '../data/repositories/care_event_repository.dart';
import 'resident_detail_view_model.dart';

class TimelineViewModel extends ChangeNotifier {
  TimelineViewModel({
    required this.resident,
    required CareEventRepository eventRepository,
  }) : _eventRepo = eventRepository;

  final Resident resident;
  final CareEventRepository _eventRepo;

  SectionState<List<CareEvent>> _timeline = const SectionState();

  SectionState<List<CareEvent>> get timeline => _timeline;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> loadTimeline() async {
    _timeline = _timeline.copyWith(status: SectionStatus.loading);
    _notify();
    try {
      final envelope = await _eventRepo.listRawTimeline(resident.id);
      
      // Privacy filtering
      final familyTimeline = envelope.data
          .where((e) => e.visibility != Visibility.residentOnly)
          .where((e) {
            return switch (e) {
              MedicationEvent() => resident.sharingPreferences.shareMedicationStatus,
              MealEvent() => resident.sharingPreferences.shareMealStatus,
              ActivityEvent() => resident.sharingPreferences.shareActivityDetails,
            };
          })
          .toList(growable: false);

      _timeline = SectionState(status: SectionStatus.ready, data: familyTimeline);
    } catch (e) {
      String message = 'An unexpected error occurred.';
      if (e is MockApiError) {
        message = e.message;
      }
      _timeline = SectionState(
        status: SectionStatus.error,
        errorMessage: message,
      );
    }
    _notify();
  }
}
