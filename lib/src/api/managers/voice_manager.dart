import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

class VoiceManager {
  late final GuildMember member;
  bool isDeaf;
  bool isMute;
  bool isSelfMute;
  bool isSelfDeaf;
  bool hasVideo;
  bool? hasStream;
  VoiceChannel? channel;

  VoiceManager({
    required this.isMute,
    required this.isDeaf,
    required this.isSelfMute,
    required this.isSelfDeaf,
    required this.hasVideo,
    required this.hasStream,
    required this.channel
  });

  Future<void> setMute(bool value) async {
    final Http http = ioc.singleton(ioc.services.http);
    final Response response = await http.patch(
      url: '/guilds/${member.guild.id}/members/${member.user.id}',
      payload: {'mute': value}
    );

    if (response.statusCode == 204 || response.statusCode == 200) {
      isMute = value;
    }
  }

  Future<void> setDeaf(bool value) async {
    final Http http = ioc.singleton(ioc.services.http);
    final Response response = await http.patch(
      url: '/guilds/${member.guild.id}/members/${member.user.id}',
      payload: {'deaf': value}
    );

    if (response.statusCode == 204 || response.statusCode == 200) {
      isDeaf = value;
    }
  }

  Future<void> move(Snowflake channelId) async {
    final Http http = ioc.singleton(ioc.services.http);
    final Response response = await http.patch(
      url: '/guilds/${member.guild.id}/members/${member.user.id}',
      payload: {'channel_id': channelId}
    );

    if (response.statusCode == 204 || response.statusCode == 200) {
      final VoiceChannel? channel = member.guild.channels.cache.get(channelId);
      if (channel != null) {
        this.channel = channel;
      }
    }
  }

  factory VoiceManager.from(dynamic payload, VoiceChannel? channel) {
    return VoiceManager(
      isMute: payload['mute'],
      isDeaf: payload['deaf'],
      isSelfMute: payload['self_mute'],
      isSelfDeaf: payload['self_deaf'],
      hasVideo: payload['self_video'],
      hasStream: payload['self_stream'],
      channel: channel
    );
  }


}