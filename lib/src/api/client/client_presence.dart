import 'package:mineral/core/api.dart';

enum GamePresence {
  game(0),
  streaming(1),
  listening(2),
  watching(3),
  custom(4),
  competing(5);

  final int value;

  const GamePresence(this.value);

  @override
  String toString () => value.toString();
}

class Timestamp {
  DateTime? start;
  DateTime? end;

  Timestamp({ required this.start, required this.end });

  factory Timestamp.from ({ required dynamic payload }) {
    return Timestamp(
      start: payload['start'] != null ? DateTime.fromMillisecondsSinceEpoch(payload['start']) : null,
      end: payload['end'] != null ? DateTime.fromMillisecondsSinceEpoch(payload['end']) : null,
    );
  }
}

class ClientPresence {
  String? _label;
  int _type;
  String? _url;
  String _createdAt;
  Timestamp? _timestamps;
  Snowflake? _applicationId;
  String? _details;
  String? _state;
  // Emoji? emoji;
  // Party? party;
  // Asset? assets;
  // Secret? secrets;
  // Instance? instance;
  int? _flags;
  // List<Button> buttons;

  ClientPresence(
    this._label,
    this._type,
    this._url,
    this._createdAt,
    this._timestamps,
    this._applicationId,
    this._details,
    this._state,
    this._flags,
  );

  /// Get label of this
  String? get label => _label;
  /// Get type of this
  GamePresence get type => GamePresence.values.firstWhere((type) => type.value == _type);
  /// Get url of this
  String? get url => _url;
  /// Get created time of this
  DateTime get createdAt => DateTime.parse(_createdAt);
  /// Get timestamps of this
  Timestamp? get timestamps =>  _timestamps != null ? Timestamp.from(payload: _timestamps) : null;
  /// Get application id of this
  Snowflake? get applicationId => _applicationId;
  /// Get details of this
  String? get details => _details;
  /// Get state of this
  String? get state => _state;
  /// Get flags of this
  int? get flags => _flags;

  factory ClientPresence.from({ required dynamic payload }) {
    return ClientPresence(
      payload['name'],
      payload['type'],
      payload['url'],
      payload['createdAt'],
      payload['timestamps'],
      payload['application_id'],
      payload['details'],
      payload['state'],
      payload['flags']
    );
  }
}
