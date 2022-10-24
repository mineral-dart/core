import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class MemberSelfMuteEvent extends Event {
  final GuildMember _member;

  MemberSelfMuteEvent(this._member);

  GuildMember get member => _member;
}