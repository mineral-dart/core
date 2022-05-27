part of api;

enum PresenceType {
  game(0),
  streaming(1),
  listening(2),
  watching(3),
  custom(4),
  competing(5);

  final int _value;

  const PresenceType(this._value);

  @override
  String toString () => _value.toString();
}

class Timestamp {
  DateTime? start;
  DateTime? end;

  Timestamp({ required this.start, required this.end });

  factory Timestamp.from ({ required dynamic payload }) {
    return Timestamp(
      start: payload['start'] ? DateTime.fromMillisecondsSinceEpoch(payload['start']) : null,
      end: payload['end'] ? DateTime.fromMillisecondsSinceEpoch(payload['start']) : null,
    );
  }
}

class Presence {
  String label;
  PresenceType type;
  String? url;
  DateTime createdAt;
  Timestamp timestamps;
  Snowflake? applicationId;
  String? details;
  String? state;
  // Emoji? emoji;
  // Party? party;
  // Asset? assets;
  // Secret? secrets;
  // Instance? instance;
  int? flags;

  // List<Button> buttons;

  Presence({
    required this.label,
    required this.type,
    required this.url,
    required this.createdAt,
    required this.timestamps,
    required this.applicationId,
    required this.details,
    required this.state,
    required this.flags,
  });

  factory Presence.from({ required dynamic payload }) {
    return Presence(
      label: payload['name'],
      type: payload['type'],
      url: payload['url'],
      createdAt: DateTime.parse(payload['createdAt']),
      timestamps: Timestamp.from(payload: payload['timestamps']),
      applicationId: payload['application_id'],
      details: payload['details'],
      state: payload['state'],
      flags: payload['flags']
    );
  }
}
