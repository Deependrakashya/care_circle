import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../models/json_parsing.dart';
import '../models/starter_health.dart';
import 'care_circle_api.dart';
import 'incident_state.dart';
import 'mock_api_error.dart';

/// Canonical fixture date, matching the reference `FIXTURE_DATE = '2026-09-19'`.
const String fixtureDate = '2026-09-19';

class MockCareCircleApi implements CareCircleApi {
  MockCareCircleApi({AssetBundle? bundle, this.delay})
    : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  final Duration? delay;

  Future<void> _wait([int minimum = 220, int spread = 380]) =>
      Future<void>.delayed(
        delay ?? Duration(milliseconds: minimum + Random().nextInt(spread)),
      );

  /// Loads a JSON asset, decodes it, and wraps in an envelope with generatedAt.
  Future<JsonMap> _loadAndEnvelope(String assetPath) async {
    final source = await _bundle.loadString(assetPath);
    return {
      'data': jsonDecode(source),
      'generatedAt': DateTime.now().toUtc().toIso8601String(),
    };
  }

  @override
  Future<StarterHealth> getStarterHealth() async {
    await _wait(80, 120);
    final residentsSource = await _bundle.loadString(
      'assets/data/residents.json',
    );
    final residents = jsonDecode(residentsSource) as List;
    final timelineSource = await _bundle.loadString(
      'assets/data/raw_timeline.json',
    );
    final timeline = jsonDecode(timelineSource) as List;
    return StarterHealth(
      residentCount: residents.length,
      timelineRecordCount: timeline.length,
      vitalsIncident: IncidentState.vitals503,
      fixtureDate: fixtureDate,
    );
  }

  @override
  Future<JsonMap> listResidents() async {
    await _wait();
    return _loadAndEnvelope('assets/data/residents.json');
  }

  @override
  Future<JsonMap> getResident(String residentId) async {
    await _wait();
    final source = await _bundle.loadString('assets/data/residents.json');
    final residents = jsonDecode(source) as List;
    final resident = residents.cast<Map<String, dynamic>>().where(
      (item) => item['id'] == residentId,
    );
    if (resident.isEmpty) {
      throw const MockApiError(
        'Resident not found',
        status: 404,
        code: 'RESIDENT_NOT_FOUND',
      );
    }
    return {
      'data': resident.first,
      'generatedAt': DateTime.now().toUtc().toIso8601String(),
    };
  }

  @override
  Future<JsonMap> getDailySummary(String residentId) async {
    await _wait();
    final source = await _bundle.loadString(
      'assets/data/daily_summaries.json',
    );
    final summaries = (jsonDecode(source) as List).cast<Map<String, dynamic>>();
    final match = summaries.where(
      (item) => item['residentId'] == residentId,
    );
    return {
      'data': match.isEmpty ? null : match.first,
      'generatedAt': DateTime.now().toUtc().toIso8601String(),
    };
  }

  @override
  Future<JsonMap> listCareEvents(String residentId) async {
    await _wait();
    final source = await _bundle.loadString('assets/data/care_events.json');
    final events = (jsonDecode(source) as List).cast<Map<String, dynamic>>();
    final filtered =
        events.where((item) => item['residentId'] == residentId).toList();
    return {
      'data': filtered,
      'generatedAt': DateTime.now().toUtc().toIso8601String(),
    };
  }

  @override
  Future<JsonMap> listRawTimeline(String residentId) async {
    await _wait();
    final source = await _bundle.loadString('assets/data/raw_timeline.json');
    final records = jsonDecode(source) as List;
    // Filter by residentId like the reference, but records may not be typed.
    final filtered = records.where((item) {
      if (item is! Map<String, dynamic>) return false;
      return item['residentId'] == residentId;
    }).toList();
    return {
      'data': filtered,
      'generatedAt': DateTime.now().toUtc().toIso8601String(),
    };
  }

  @override
  Future<JsonMap> listVitals(String residentId) async {
    await _wait(350, 650);

    // Check runtime incident state.
    if (IncidentState.vitals503) {
      throw const MockApiError(
        'Vitals service is temporarily unavailable',
        status: 503,
        code: 'VITALS_UNAVAILABLE',
      );
    }

    final source = await _bundle.loadString('assets/data/vitals.json');
    final vitals = (jsonDecode(source) as List).cast<Map<String, dynamic>>();
    final filtered =
        vitals.where((item) => item['residentId'] == residentId).toList();
    return {
      'data': filtered,
      'generatedAt': DateTime.now().toUtc().toIso8601String(),
    };
  }

  @override
  Future<JsonMap> listStaffUpdates(String residentId) async {
    await _wait();
    final source = await _bundle.loadString('assets/data/staff_updates.json');
    final updates = (jsonDecode(source) as List).cast<Map<String, dynamic>>();
    final filtered =
        updates.where((item) => item['residentId'] == residentId).toList();
    return {
      'data': filtered,
      'generatedAt': DateTime.now().toUtc().toIso8601String(),
    };
  }

  @override
  Future<JsonMap> createCheckInRequest(JsonMap input) async {
    await _wait(500, 500);

    final reason = input['reason'];
    if (reason is! String || reason.trim().isEmpty) {
      throw const MockApiError(
        'A reason is required',
        status: 422,
        code: 'INVALID_REASON',
      );
    }

    return {
      'data': {
        ...input,
        'id': 'check-${DateTime.now().millisecondsSinceEpoch}',
        'createdAt': DateTime.now().toUtc().toIso8601String(),
        'status': 'received',
      },
      'generatedAt': DateTime.now().toUtc().toIso8601String(),
    };
  }
}
