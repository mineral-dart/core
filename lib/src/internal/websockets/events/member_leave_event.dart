import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class MemberLeaveEvent extends Event {
  final GuildMember _member;

  MemberLeaveEvent(this._member);

  GuildMember get member => _member;
}
