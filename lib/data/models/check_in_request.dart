import 'json_parsing.dart';

enum CheckInUrgency { routine, soon }

class CheckInRequestInput {
  const CheckInRequestInput({
    required this.residentId,
    required this.reason,
    required this.urgency,
  });

  final String residentId;
  final String reason;
  final CheckInUrgency urgency;

  Map<String, dynamic> toJson() => {
    'residentId': residentId,
    'reason': reason,
    'urgency': switch (urgency) {
      CheckInUrgency.routine => 'routine',
      CheckInUrgency.soon => 'soon',
    },
  };
}

class CheckInRequest {
  const CheckInRequest({
    required this.id,
    required this.residentId,
    required this.reason,
    required this.urgency,
    required this.createdAt,
    required this.status,
  });

  factory CheckInRequest.fromJson(JsonMap json) {
    final urgency = switch (requireString(json, 'urgency')) {
      'routine' => CheckInUrgency.routine,
      'soon' => CheckInUrgency.soon,
      final other => throw FormatException(
        'Invalid check-in urgency: $other.',
      ),
    };

    return CheckInRequest(
      id: requireString(json, 'id'),
      residentId: requireString(json, 'residentId'),
      reason: requireString(json, 'reason'),
      urgency: urgency,
      createdAt: requireDateTime(json, 'createdAt'),
      status: requireString(json, 'status'),
    );
  }

  final String id;
  final String residentId;
  final String reason;
  final CheckInUrgency urgency;
  final DateTime createdAt;

  /// Always 'received' from the mock API.
  final String status;
}
