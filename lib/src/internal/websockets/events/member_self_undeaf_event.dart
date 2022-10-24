import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class MemberSelfUndeafEvent extends Event {
  final GuildMember _member;

  MemberSelfUndeafEvent(this._member);

  GuildMember get member => _member;
}