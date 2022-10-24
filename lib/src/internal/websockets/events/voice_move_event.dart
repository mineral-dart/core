import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class VoiceMoveEvent extends Event {
  final GuildMember _member;
  final VoiceChannel _before;
  final VoiceChannel _after;

  VoiceMoveEvent(this._member, this._before, this._after);

  GuildMember get member => _member;
  VoiceChannel get before => _before;
  VoiceChannel get after => _after;
}