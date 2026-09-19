import 'json_parsing.dart';

enum StaffNoteSharing { all, limited, none }

class SharingPreferences {
  const SharingPreferences({
    required this.shareMedicationStatus,
    required this.shareMealStatus,
    required this.shareActivityDetails,
    required this.shareVitalDetails,
    required this.shareStaffNotes,
    required this.sharePhotos,
  });

  factory SharingPreferences.fromJson(JsonMap json) {
    final staffNotes = switch (json['shareStaffNotes']) {
      'all' => StaffNoteSharing.all,
      'limited' => StaffNoteSharing.limited,
      'none' => StaffNoteSharing.none,
      _ => throw const FormatException(
        'Invalid staff note sharing preference.',
      ),
    };
    return SharingPreferences(
      shareMedicationStatus: requireBool(json, 'shareMedicationStatus'),
      shareMealStatus: requireBool(json, 'shareMealStatus'),
      shareActivityDetails: requireBool(json, 'shareActivityDetails'),
      shareVitalDetails: requireBool(json, 'shareVitalDetails'),
      shareStaffNotes: staffNotes,
      sharePhotos: requireBool(json, 'sharePhotos'),
    );
  }

  final bool shareMedicationStatus;
  final bool shareMealStatus;
  final bool shareActivityDetails;
  final bool shareVitalDetails;
  final StaffNoteSharing shareStaffNotes;
  final bool sharePhotos;
}
