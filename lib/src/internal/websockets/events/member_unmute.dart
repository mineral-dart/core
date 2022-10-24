import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class MemberUnmuteEvent extends Event {
  final GuildMember _member;

  MemberUnmuteEvent(this._member);

  GuildMember get member => _member;
}