import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class MemberRoleUpdateEvent extends Event {
  final GuildMember _before;
  final GuildMember _after;

  MemberRoleUpdateEvent(this._before, this._after);

  GuildMember get before => _before;
  GuildMember get after => _after;
}
