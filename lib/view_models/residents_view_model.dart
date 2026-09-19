import 'package:flutter/foundation.dart';

import '../data/models/resident.dart';
import '../data/repositories/resident_repository.dart';

enum ResidentsStatus { initial, loading, ready, empty, error }

/// Owns all screen data and state. Views only read getters and invoke actions.
class ResidentsViewModel extends ChangeNotifier {
  ResidentsViewModel(this._repository);

  final ResidentRepository _repository;
  List<Resident> _residents = const [];
  ResidentsStatus _status = ResidentsStatus.initial;
  String? _errorMessage;
  String? _selectedResidentId;
  bool _disposed = false;

  List<Resident> get residents => _residents;
  ResidentsStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == ResidentsStatus.loading;

  Resident? get selectedResident {
    for (final resident in _residents) {
      if (resident.id == _selectedResidentId) return resident;
    }
    return null;
  }

  Future<void> loadResidents() async {
    if (_disposed || isLoading) return;
    _status = ResidentsStatus.loading;
    _errorMessage = null;
    _residents = const [];
    notifyListeners();

    try {
      final response = await _repository.listResidents();
      if (_disposed) return;
      _residents = List.unmodifiable(response.data);
      if (!_residents.any((resident) => resident.id == _selectedResidentId)) {
        _selectedResidentId = _residents.firstOrNull?.id;
      }
      _status = _residents.isEmpty
          ? ResidentsStatus.empty
          : ResidentsStatus.ready;
    } on FormatException {
      if (_disposed) return;
      _status = ResidentsStatus.error;
      _errorMessage =
          'We could not read your relatives’ information. Try again.';
    } catch (_) {
      if (_disposed) return;
      _status = ResidentsStatus.error;
      _errorMessage = 'Your relatives could not be loaded. Please try again.';
    }
    notifyListeners();
  }

  void selectResident(String residentId) {
    if (_disposed ||
        _status != ResidentsStatus.ready ||
        residentId == _selectedResidentId ||
        !_residents.any((resident) => resident.id == residentId)) {
      return;
    }
    _selectedResidentId = residentId;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
