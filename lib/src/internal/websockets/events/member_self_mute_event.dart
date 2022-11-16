import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class MemberSelfMuteEvent extends Event {
  final GuildMember _member;

  MemberSelfMuteEvent(this._member);

  GuildMember get member => _member;
}