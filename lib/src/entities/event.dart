part of core;

class Event {
  final String type = 'event';
  final EventList event;

  const Event(this.event);
}

enum EventList {
  ready('ready'),
  guildCreate('create::guild'),
  presenceUpdate('update::presence'),
  messageCreate('create::message'),
  messageUpdate('update::message'),
  messageDelete('delete::message'),
  channelCreate('create::channel'),
  channelDelete('delete::channel');

  final String event;
  const EventList(this.event);

  @override
  String toString() => event;
}
