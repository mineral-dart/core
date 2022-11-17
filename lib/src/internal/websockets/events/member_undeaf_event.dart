import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class MemberUndeafEvent extends Event {
  final GuildMember _member;

  MemberUndeafEvent(this._member);

  GuildMember get member => _member;
}