import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class MemberLeaveEvent extends Event {
  final GuildMember _member;

  MemberLeaveEvent(this._member);

  GuildMember get member => _member;
}
