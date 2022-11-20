import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class MemberSelfUnmuteEvent extends Event {
  final GuildMember _member;

  MemberSelfUnmuteEvent(this._member);

  GuildMember get member => _member;
}