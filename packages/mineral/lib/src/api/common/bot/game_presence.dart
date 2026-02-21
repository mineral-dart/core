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
