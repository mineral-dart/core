import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class MemberSelfDeafEvent extends Event {
  final GuildMember _member;

  MemberSelfDeafEvent(this._member);

  GuildMember get member => _member;
}