import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class MemberSelfUndeafEvent extends Event {
  final GuildMember _member;

  MemberSelfUndeafEvent(this._member);

  GuildMember get member => _member;
}