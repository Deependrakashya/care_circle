import 'dart:async';

import 'package:care_circle/data/models/json_parsing.dart';
import 'package:care_circle/data/repositories/resident_repository.dart';
import 'package:care_circle/view_models/residents_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fixtures.dart';

ResidentsViewModel createViewModel(Future<JsonMap> Function() respond) =>
    ResidentsViewModel(ApiResidentRepository(StubApi(respond)));

void main() {
  test(
    'owns loading, data, selection, and prevents overlapping requests',
    () async {
      final request = Completer<JsonMap>();
      var calls = 0;
      final vm = createViewModel(() {
        calls++;
        return request.future;
      });
      addTearDown(vm.dispose);
      expect(vm.status, ResidentsStatus.initial);
      final pending = vm.loadResidents();
      expect(vm.isLoading, true);
      expect(vm.residents, isEmpty);
      await vm.loadResidents();
      expect(calls, 1);
      request.complete(residentResponse());
      await pending;
      expect(vm.status, ResidentsStatus.ready);
      expect(vm.selectedResident?.id, 'resident-meera');
      vm.selectResident('resident-devendra');
      expect(vm.selectedResident?.id, 'resident-devendra');
      vm.selectResident('not-a-resident');
      expect(vm.selectedResident?.id, 'resident-devendra');
      expect(() => vm.residents.clear(), throwsUnsupportedError);
    },
  );

  test(
    'refresh preserves valid selection and removes residents no longer available',
    () async {
      var response = residentResponse();
      final vm = createViewModel(() async => response);
      addTearDown(vm.dispose);
      await vm.loadResidents();
      vm.selectResident('resident-devendra');
      await vm.loadResidents();
      expect(vm.selectedResident?.id, 'resident-devendra');
      response = residentResponse();
      response['data'].removeLast();
      await vm.loadResidents();
      expect(vm.selectedResident?.id, 'resident-meera');
      response = residentResponse()..['data'] = [];
      await vm.loadResidents();
      expect(vm.status, ResidentsStatus.empty);
      expect(vm.selectedResident, isNull);
      expect(vm.errorMessage, isNull);
    },
  );

  test(
    'error is safe to display, retry clears it, failed refresh clears old data',
    () async {
      var fail = true;
      final vm = createViewModel(() async {
        if (fail) throw Exception('sensitive transport payload');
        return residentResponse();
      });
      addTearDown(vm.dispose);
      await vm.loadResidents();
      expect(vm.status, ResidentsStatus.error);
      expect(vm.errorMessage, isNot(contains('sensitive')));
      expect(vm.isLoading, false);
      fail = false;
      await vm.loadResidents();
      expect(vm.status, ResidentsStatus.ready);
      expect(vm.errorMessage, isNull);
      fail = true;
      await vm.loadResidents();
      expect(vm.residents, isEmpty);
      expect(vm.selectedResident, isNull);
    },
  );

  test('parsing failure produces a recoverable view-model error', () async {
    final vm = createViewModel(() async => residentResponse()..['data'] = null);
    addTearDown(vm.dispose);
    await vm.loadResidents();
    expect(vm.status, ResidentsStatus.error);
    expect(vm.errorMessage, contains('could not read'));
    expect(vm.residents, isEmpty);
  });

  for (final fails in [false, true]) {
    test(
      'late ${fails ? 'failure' : 'success'} after disposal never notifies',
      () async {
        final request = Completer<JsonMap>();
        final vm = createViewModel(() => request.future);
        var notifications = 0;
        vm.addListener(() => notifications++);
        final pending = vm.loadResidents();
        expect(notifications, 1);
        vm.dispose();
        if (fails) {
          request.completeError(Exception('request failed'));
        } else {
          request.complete(residentResponse());
        }
        await pending;
        await vm.loadResidents();
        vm.selectResident('resident-meera');
        expect(notifications, 1);
      },
    );
  }
}
