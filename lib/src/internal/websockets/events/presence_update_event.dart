import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class PresenceUpdateEvent extends Event {
  final GuildMember? _before;
  final GuildMember? _after;

  PresenceUpdateEvent(this._before, this._after);

  GuildMember? get before => _before;
  GuildMember? get after => _after;
}
