import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class GuildScheduledEventDeleteEvent extends Event {
  final GuildScheduledEvent _scheduledEvent;

  GuildScheduledEventDeleteEvent(this._scheduledEvent);

  GuildScheduledEvent get scheduledEvent => _scheduledEvent;
}