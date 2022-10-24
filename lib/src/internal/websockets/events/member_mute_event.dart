import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class MemberMuteEvent extends Event {
  final GuildMember _member;

  MemberMuteEvent(this._member);

  GuildMember get member => _member;
}