import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class MemberMuteEvent extends Event {
  final GuildMember _member;

  MemberMuteEvent(this._member);

  GuildMember get member => _member;
}