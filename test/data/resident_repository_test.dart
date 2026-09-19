import 'package:care_circle/data/api/mock_care_circle_api.dart';
import 'package:care_circle/data/models/sharing_preferences.dart';
import 'package:care_circle/data/repositories/resident_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'parses actual fixtures, nested models, and exact sharing restrictions',
    () async {
      final repository = ApiResidentRepository(
        StubApi(() async => residentResponse()),
      );
      final result = await repository.listResidents();
      expect(result.data.length, 2);
      final meera = result.data.first;
      final devendra = result.data.last;
      expect(meera.id, 'resident-meera');
      expect(meera.facility.city, 'Gurugram');
      expect(meera.timezone, 'Asia/Kolkata');
      expect(meera.sharingPreferences.shareVitalDetails, false);
      expect(meera.sharingPreferences.sharePhotos, false);
      expect(
        meera.sharingPreferences.shareStaffNotes,
        StaffNoteSharing.limited,
      );
      expect(devendra.sharingPreferences.shareMealStatus, false);
      expect(
        devendra.sharingPreferences.shareStaffNotes,
        StaffNoteSharing.none,
      );
      expect(result.generatedAt, DateTime.utc(2026, 9, 19, 5, 10));
      expect(() => result.data.clear(), throwsUnsupportedError);
    },
  );

  for (final invalid in [null, 'true', 1]) {
    test(
      'rejects malformed sharing flag $invalid instead of permitting data',
      () async {
        final json = residentResponse();
        json['data'][0]['sharingPreferences']['sharePhotos'] = invalid;
        final repository = ApiResidentRepository(StubApi(() async => json));
        await expectLater(repository.listResidents(), throwsFormatException);
      },
    );
  }

  test(
    'rejects unknown note preference, malformed resident, and duplicate IDs',
    () async {
      final unknownPreference = residentResponse();
      unknownPreference['data'][0]['sharingPreferences']['shareStaffNotes'] =
          'everyone';
      final malformedResident = residentResponse();
      malformedResident['data'][0] = null;
      final duplicate = residentResponse();
      duplicate['data'][1]['id'] = 'resident-meera';
      final badTimestamp = residentResponse()..['generatedAt'] = 'not-a-time';
      for (final json in [
        unknownPreference,
        malformedResident,
        duplicate,
        badTimestamp,
      ]) {
        await expectLater(
          ApiResidentRepository(StubApi(() async => json)).listResidents(),
          throwsFormatException,
        );
      }
    },
  );

  test('empty array is valid but invalid envelope data is rejected', () async {
    final empty = residentResponse()..['data'] = [];
    final repository = ApiResidentRepository(StubApi(() async => empty));
    expect((await repository.listResidents()).data, isEmpty);
    for (final value in [null, {}, 'invalid']) {
      final json = residentResponse()..['data'] = value;
      await expectLater(
        ApiResidentRepository(StubApi(() async => json)).listResidents(),
        throwsFormatException,
      );
    }
  });

  test('local API returns independent fixture data on every call', () async {
    final api = MockCareCircleApi(delay: Duration.zero);
    final first = await api.listResidents();
    first['data'][0]['name'] = 'Changed by caller';
    final second = await api.listResidents();
    expect(second['data'][0]['name'], 'Meera Kapoor');
    expect(DateTime.tryParse(second['generatedAt'] as String), isNotNull);
  });
}
