part of api;

enum StatusType {
  idle('idle'),
  doNotDisturb('dnd'),
  invisible('invisible'),
  online('online'),
  offline('offline');

  final String _value;
  const StatusType(this._value);

  @override
  String toString () => _value;
}

class Activity {
  String? label;
  StatusType type;
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

  Activity({
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

  factory Activity.from({ required dynamic payload }) {
    print(payload['type']);
    print(payload);
    return Activity(
      label: payload['name'],
      type: payload['type'] != null ? StatusType.values.firstWhere((status) => status.toString() == payload['type']) : StatusType.offline,
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
