import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class MemberSelfDeafEvent extends Event {
  final GuildMember _member;

  MemberSelfDeafEvent(this._member);

  GuildMember get member => _member;
}