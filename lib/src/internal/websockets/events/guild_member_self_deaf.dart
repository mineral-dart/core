import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class GuildMemberSelfDeafEvent extends Event {
  final GuildMember _member;

  GuildMemberSelfDeafEvent(this._member);

  GuildMember get member => _member;
}