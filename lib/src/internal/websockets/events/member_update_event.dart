import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class MemberUpdateEvent extends Event {
  final GuildMember _before;
  final GuildMember _after;

  MemberUpdateEvent(this._before, this._after);

  GuildMember get before => _before;
  GuildMember get after => _after;
}
