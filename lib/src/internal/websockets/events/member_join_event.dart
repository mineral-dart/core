import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class MemberJoinEvent extends Event {
  final GuildMember _member;

  MemberJoinEvent(this._member);

  GuildMember get member => _member;
  Guild get guild => _member.guild;
  User get user => _member.user;
}
