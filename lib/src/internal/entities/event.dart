abstract class Event {}

abstract class MineralEvent<Event> {
  final Type listener = Event;
  String? customId;

  Future<void> handle (Event event);
}
