import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class GuildScheduledEventUserRemoveEvent extends Event {
  final GuildScheduledEvent _scheduledEvent;
  final User _user;
  final GuildMember? _member;

  GuildScheduledEventUserRemoveEvent(this._scheduledEvent, this._user, this._member);

  GuildScheduledEvent get scheduledEvent => _scheduledEvent;
  User get user => _user;
  GuildMember? get member => _member;
}