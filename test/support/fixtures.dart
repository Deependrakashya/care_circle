import 'dart:convert';
import 'dart:io';

import 'package:care_circle/data/api/care_circle_api.dart';
import 'package:care_circle/data/models/json_parsing.dart';
import 'package:care_circle/data/models/starter_health.dart';

JsonMap residentResponse() => {
  'data': jsonDecode(File('assets/data/residents.json').readAsStringSync()),
  'generatedAt': '2026-09-19T05:10:00.000Z',
};

class StubApi implements CareCircleApi {
  StubApi(this.respond);

  final Future<JsonMap> Function() respond;

  @override
  Future<StarterHealth> getStarterHealth() => throw UnimplementedError();

  @override
  Future<JsonMap> listResidents() => respond();

  @override
  Future<JsonMap> getResident(String residentId) =>
      throw UnimplementedError();

  @override
  Future<JsonMap> getDailySummary(String residentId) =>
      throw UnimplementedError();

  @override
  Future<JsonMap> listCareEvents(String residentId) =>
      throw UnimplementedError();

  @override
  Future<JsonMap> listRawTimeline(String residentId) =>
      throw UnimplementedError();

  @override
  Future<JsonMap> listVitals(String residentId) =>
      throw UnimplementedError();

  @override
  Future<JsonMap> listStaffUpdates(String residentId) =>
      throw UnimplementedError();

  @override
  Future<JsonMap> createCheckInRequest(JsonMap input) =>
      throw UnimplementedError();
}
