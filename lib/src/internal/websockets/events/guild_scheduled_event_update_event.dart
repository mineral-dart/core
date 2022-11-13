import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class GuildScheduledEventUpdateEvent extends Event {
  final GuildScheduledEvent? _before;
  final GuildScheduledEvent _after;

  GuildScheduledEventUpdateEvent(this._before, this._after);

  GuildScheduledEvent? get before => _before;
  GuildScheduledEvent get after => _after;
}