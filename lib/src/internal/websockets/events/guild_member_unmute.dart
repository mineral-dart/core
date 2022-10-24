import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class GuildMemberUnmuteEvent extends Event {
  final GuildMember _member;

  GuildMemberUnmuteEvent(this._member);

  GuildMember get member => _member;
}