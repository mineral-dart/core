import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class GuildMemberUndeafEvent extends Event {
  final GuildMember _member;

  GuildMemberUndeafEvent(this._member);

  GuildMember get member => _member;
}