import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class VoiceJoinEvent extends Event {
  final GuildMember _member;
  final VoiceChannel? _before;
  final VoiceChannel _after;

  VoiceJoinEvent(this._member, this._before, this._after);

  GuildMember get member => _member;
  VoiceChannel? get before => _before;
  VoiceChannel get after => _after;
}