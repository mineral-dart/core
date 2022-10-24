import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class GuildMemberMuteEvent extends Event {
  final GuildMember _member;

  GuildMemberMuteEvent(this._member);

  GuildMember get member => _member;
}