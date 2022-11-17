import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class VoiceLeaveEvent extends Event {
  final GuildMember _member;
  final VoiceChannel _channel;

  VoiceLeaveEvent(this._member, this._channel);

  GuildMember get member => _member;
  VoiceChannel get channel => _channel;
}