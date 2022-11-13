import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class GuildScheduledEventDeleteEvent extends Event {
  final GuildScheduledEvent _scheduledEvent;

  GuildScheduledEventDeleteEvent(this._scheduledEvent);

  GuildScheduledEvent get scheduledEvent => _scheduledEvent;
}