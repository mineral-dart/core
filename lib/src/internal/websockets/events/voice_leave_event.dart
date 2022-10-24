import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class VoiceLeaveEvent extends Event {
  final GuildMember _member;
  final VoiceChannel _channel;

  VoiceLeaveEvent(this._member, this._channel);

  GuildMember get member => _member;
  VoiceChannel get channel => _channel;
}