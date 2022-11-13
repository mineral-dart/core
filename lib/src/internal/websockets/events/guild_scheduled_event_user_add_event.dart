import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class GuildScheduledEventUserAddEvent extends Event {
  final GuildScheduledEvent _scheduledEvent;
  final User _user;
  final GuildMember? _member;

  GuildScheduledEventUserAddEvent(this._scheduledEvent, this._user, this._member);

  GuildScheduledEvent get scheduledEvent => _scheduledEvent;
  User get user => _user;
  GuildMember? get member => _member;
}