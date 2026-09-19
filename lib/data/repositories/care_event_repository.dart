import 'package:flutter/foundation.dart';

import '../api/care_circle_api.dart';
import '../models/api_envelope.dart';
import '../models/care_event.dart';
import '../models/json_parsing.dart';

abstract interface class CareEventRepository {
  /// Returns parsed, valid care events for a resident.
  Future<ApiEnvelope<List<CareEvent>>> listCareEvents(String residentId);

  /// Returns whatever the raw timeline endpoint provides, skipping records
  /// that fail validation. Malformed records are logged but do not crash.
  Future<ApiEnvelope<List<CareEvent>>> listRawTimeline(String residentId);
}

class ApiCareEventRepository implements CareEventRepository {
  const ApiCareEventRepository(this._api);

  final CareCircleApi _api;

  @override
  Future<ApiEnvelope<List<CareEvent>>> listCareEvents(
    String residentId,
  ) async {
    final json = await _api.listCareEvents(residentId);
    return ApiEnvelope.fromJson(json, (value) {
      if (value is! List) {
        throw const FormatException('Expected a care-event list.');
      }
      final events = value
          .map((item) => CareEvent.fromJson(requireObject(item, 'careEvent')))
          .toList(growable: false);
      return List<CareEvent>.unmodifiable(events);
    });
  }

  @override
  Future<ApiEnvelope<List<CareEvent>>> listRawTimeline(
    String residentId,
  ) async {
    final json = await _api.listRawTimeline(residentId);
    return ApiEnvelope.fromJson(json, (value) {
      if (value is! List) {
        throw const FormatException('Expected a raw-timeline list.');
      }
      final events = <CareEvent>[];
      for (final item in value) {
        try {
          events.add(
            CareEvent.fromJson(requireObject(item, 'timelineRecord')),
          );
        } on FormatException catch (e) {
          // Malformed records are deliberately included in the fixture.
          // Skip and log instead of crashing.
          debugPrint('Skipped malformed timeline record: $e');
        }
      }
      return List<CareEvent>.unmodifiable(events);
    });
  }
}
