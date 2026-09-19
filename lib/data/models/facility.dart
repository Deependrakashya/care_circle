import 'json_parsing.dart';

class Facility {
  const Facility({required this.id, required this.name, required this.city});

  factory Facility.fromJson(JsonMap json) => Facility(
    id: requireString(json, 'id'),
    name: requireString(json, 'name'),
    city: requireString(json, 'city'),
  );

  final String id;
  final String name;
  final String city;
}
