import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class MemberSelfUnmuteEvent extends Event {
  final GuildMember _member;

  MemberSelfUnmuteEvent(this._member);

  GuildMember get member => _member;
}