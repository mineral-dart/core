import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class MemberDeafEvent extends Event {
  final GuildMember _member;

  MemberDeafEvent(this._member);

  GuildMember get member => _member;
}