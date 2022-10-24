import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class GuildMemberSelfUnmuteEvent extends Event {
  final GuildMember _member;

  GuildMemberSelfUnmuteEvent(this._member);

  GuildMember get member => _member;
}