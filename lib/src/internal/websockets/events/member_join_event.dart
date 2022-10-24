import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class MemberJoinEvent extends Event {
  final GuildMember _member;

  MemberJoinEvent(this._member);

  GuildMember get member => _member;
}
