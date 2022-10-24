import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class GuildMemberSelfUndeafEvent extends Event {
  final GuildMember _member;

  GuildMemberSelfUndeafEvent(this._member);

  GuildMember get member => _member;
}