import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class GuildMemberSelfMuteEvent extends Event {
  final GuildMember _member;

  GuildMemberSelfMuteEvent(this._member);

  GuildMember get member => _member;
}