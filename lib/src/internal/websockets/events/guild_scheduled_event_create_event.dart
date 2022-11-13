import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class GuildScheduledEventCreateEvent extends Event {
  final GuildScheduledEvent _scheduledEvent;

  GuildScheduledEventCreateEvent(this._scheduledEvent);

  GuildScheduledEvent get scheduledEvent => _scheduledEvent;
}