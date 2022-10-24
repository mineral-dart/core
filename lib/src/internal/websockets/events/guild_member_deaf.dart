import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class GuildMemberDeafEvent extends Event {
  final GuildMember _member;

  GuildMemberDeafEvent(this._member);

  GuildMember get member => _member;
}