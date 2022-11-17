import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class GuildScheduledEventCreateEvent extends Event {
  final GuildScheduledEvent _scheduledEvent;

  GuildScheduledEventCreateEvent(this._scheduledEvent);

  GuildScheduledEvent get scheduledEvent => _scheduledEvent;
}