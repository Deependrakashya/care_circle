import 'json_parsing.dart';
import 'visibility.dart';

enum EventCategory { medication, meal, activity }

enum MedicationStatus { taken, missed, delayed, unknown }

enum MealStatus { completed, partial, skipped, unknown }

enum MealType { breakfast, lunch, dinner, snack }

enum ActivityStatus { completed, cancelled, unknown }

/// Base care event. Use the typed subclasses for category-specific fields.
sealed class CareEvent {
  const CareEvent({
    required this.id,
    required this.residentId,
    required this.category,
    required this.recordedAt,
    required this.visibility,
    this.scheduledAt,
    this.note,
  });

  /// Dispatches to the correct subclass based on the `category` field.
  /// Throws [FormatException] for unknown categories or invalid fields.
  factory CareEvent.fromJson(JsonMap json) {
    final category = requireString(json, 'category');
    return switch (category) {
      'medication' => MedicationEvent._fromJson(json),
      'meal' => MealEvent._fromJson(json),
      'activity' => ActivityEvent._fromJson(json),
      _ => throw FormatException('Unknown event category: $category.'),
    };
  }

  final String id;
  final String residentId;
  final EventCategory category;
  final DateTime? scheduledAt;
  final DateTime recordedAt;
  final Visibility visibility;
  final String? note;
}

class MedicationEvent extends CareEvent {
  const MedicationEvent({
    required super.id,
    required super.residentId,
    required super.recordedAt,
    required super.visibility,
    required this.medicationLabel,
    required this.status,
    super.scheduledAt,
    super.note,
  }) : super(category: EventCategory.medication);

  factory MedicationEvent._fromJson(JsonMap json) {
    final status = switch (requireString(json, 'status')) {
      'taken' => MedicationStatus.taken,
      'missed' => MedicationStatus.missed,
      'delayed' => MedicationStatus.delayed,
      'unknown' => MedicationStatus.unknown,
      final other => throw FormatException(
        'Invalid medication status: $other.',
      ),
    };

    return MedicationEvent(
      id: requireString(json, 'id'),
      residentId: requireString(json, 'residentId'),
      recordedAt: requireDateTime(json, 'recordedAt'),
      visibility: parseVisibility(json, 'visibility'),
      scheduledAt: optionalDateTime(json, 'scheduledAt'),
      note: optionalString(json, 'note'),
      medicationLabel: requireString(json, 'medicationLabel'),
      status: status,
    );
  }

  final String medicationLabel;
  final MedicationStatus status;
}

class MealEvent extends CareEvent {
  const MealEvent({
    required super.id,
    required super.residentId,
    required super.recordedAt,
    required super.visibility,
    required this.mealType,
    required this.status,
    super.scheduledAt,
    super.note,
  }) : super(category: EventCategory.meal);

  factory MealEvent._fromJson(JsonMap json) {
    final status = switch (requireString(json, 'status')) {
      'completed' => MealStatus.completed,
      'partial' => MealStatus.partial,
      'skipped' => MealStatus.skipped,
      'unknown' => MealStatus.unknown,
      final other => throw FormatException('Invalid meal status: $other.'),
    };

    final mealType = switch (requireString(json, 'mealType')) {
      'breakfast' => MealType.breakfast,
      'lunch' => MealType.lunch,
      'dinner' => MealType.dinner,
      'snack' => MealType.snack,
      final other => throw FormatException('Invalid meal type: $other.'),
    };

    return MealEvent(
      id: requireString(json, 'id'),
      residentId: requireString(json, 'residentId'),
      recordedAt: requireDateTime(json, 'recordedAt'),
      visibility: parseVisibility(json, 'visibility'),
      scheduledAt: optionalDateTime(json, 'scheduledAt'),
      note: optionalString(json, 'note'),
      mealType: mealType,
      status: status,
    );
  }

  final MealType mealType;
  final MealStatus status;
}

class ActivityEvent extends CareEvent {
  const ActivityEvent({
    required super.id,
    required super.residentId,
    required super.recordedAt,
    required super.visibility,
    required this.activityType,
    required this.status,
    super.scheduledAt,
    super.note,
    this.durationMinutes,
  }) : super(category: EventCategory.activity);

  factory ActivityEvent._fromJson(JsonMap json) {
    final status = switch (requireString(json, 'status')) {
      'completed' => ActivityStatus.completed,
      'cancelled' => ActivityStatus.cancelled,
      'unknown' => ActivityStatus.unknown,
      final other => throw FormatException(
        'Invalid activity status: $other.',
      ),
    };

    return ActivityEvent(
      id: requireString(json, 'id'),
      residentId: requireString(json, 'residentId'),
      recordedAt: requireDateTime(json, 'recordedAt'),
      visibility: parseVisibility(json, 'visibility'),
      scheduledAt: optionalDateTime(json, 'scheduledAt'),
      note: optionalString(json, 'note'),
      activityType: requireString(json, 'activityType'),
      durationMinutes: optionalInt(json, 'durationMinutes'),
      status: status,
    );
  }

  final String activityType;
  final int? durationMinutes;
  final ActivityStatus status;
}
