import 'facility.dart';
import 'json_parsing.dart';
import 'sharing_preferences.dart';

class Resident {
  const Resident({
    required this.id,
    required this.name,
    required this.avatarInitials,
    required this.relationship,
    required this.facility,
    required this.timezone,
    required this.sharingPreferences,
  });

  factory Resident.fromJson(JsonMap json) => Resident(
    id: requireString(json, 'id'),
    name: requireString(json, 'name'),
    avatarInitials: requireString(json, 'avatarInitials'),
    relationship: requireString(json, 'relationship'),
    facility: Facility.fromJson(requireObject(json['facility'], 'facility')),
    timezone: requireString(json, 'timezone'),
    sharingPreferences: SharingPreferences.fromJson(
      requireObject(json['sharingPreferences'], 'sharingPreferences'),
    ),
  );

  final String id;
  final String name;
  final String avatarInitials;
  final String relationship;
  final Facility facility;
  final String timezone;
  final SharingPreferences sharingPreferences;
}
