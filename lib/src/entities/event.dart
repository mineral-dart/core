part of core;

class Event {
  final String type = 'event';
  final EventList event;

  const Event(this.event);
}

enum EventList {
  ready('ready'),
  guildCreate('create::guild');

  final String event;
  const EventList(this.event);

  @override
  String toString() => event;
}
