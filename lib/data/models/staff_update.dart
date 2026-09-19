import 'json_parsing.dart';
import 'visibility.dart';

class StaffUpdate {
  const StaffUpdate({
    required this.id,
    required this.residentId,
    required this.createdAt,
    required this.authorRole,
    required this.visibility,
    this.text,
    this.mediaUrl,
  });

  factory StaffUpdate.fromJson(JsonMap json) => StaffUpdate(
    id: requireString(json, 'id'),
    residentId: requireString(json, 'residentId'),
    createdAt: requireDateTime(json, 'createdAt'),
    authorRole: requireString(json, 'authorRole'),
    text: optionalString(json, 'text'),
    mediaUrl: optionalString(json, 'mediaUrl'),
    visibility: parseVisibility(json, 'visibility'),
  );

  final String id;
  final String residentId;
  final DateTime createdAt;
  final String authorRole;
  final String? text;
  final String? mediaUrl;
  final Visibility visibility;
}
