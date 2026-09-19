// ignore_for_file: prefer_initializing_formals

import 'package:flutter/foundation.dart';

import '../data/api/mock_api_error.dart';
import '../data/models/check_in_request.dart';
import '../data/models/resident.dart';
import '../data/repositories/check_in_repository.dart';

enum CheckInSubmissionStatus { initial, submitting, success, error }

class CheckInViewModel extends ChangeNotifier {
  CheckInViewModel({
    required this.resident,
    required CheckInRepository repository,
  }) : _repository = repository;

  final Resident resident;
  final CheckInRepository _repository;

  CheckInSubmissionStatus _status = CheckInSubmissionStatus.initial;
  String? _errorMessage;

  CheckInSubmissionStatus get status => _status;
  String? get errorMessage => _errorMessage;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> submitCheckIn({
    required String reason,
    required CheckInUrgency urgency,
  }) async {
    if (_status == CheckInSubmissionStatus.submitting) return;

    _status = CheckInSubmissionStatus.submitting;
    _errorMessage = null;
    _notify();

    try {
      final input = CheckInRequestInput(
        residentId: resident.id,
        reason: reason,
        urgency: urgency,
      );
      
      await _repository.createCheckInRequest(input);
      
      _status = CheckInSubmissionStatus.success;
    } catch (e) {
      if (e is MockApiError) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'An unexpected error occurred.';
      }
      _status = CheckInSubmissionStatus.error;
    }
    _notify();
  }

  void reset() {
    _status = CheckInSubmissionStatus.initial;
    _errorMessage = null;
    _notify();
  }
}
