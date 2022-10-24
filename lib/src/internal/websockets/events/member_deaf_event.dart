import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class MemberDeafEvent extends Event {
  final GuildMember _member;

  MemberDeafEvent(this._member);

  GuildMember get member => _member;
}