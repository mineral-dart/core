import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class MemberUndeafEvent extends Event {
  final GuildMember _member;

  MemberUndeafEvent(this._member);

  GuildMember get member => _member;
}