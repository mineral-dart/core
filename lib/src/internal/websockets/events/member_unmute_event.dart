import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class MemberUnmuteEvent extends Event {
  final GuildMember _member;

  MemberUnmuteEvent(this._member);

  GuildMember get member => _member;
}