import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

class Voice {
  Snowflake? channelId;
  VoiceChannel? channel;
  bool isDeaf;
  bool isMuted;
  late GuildMember member;

  Voice({
    required this.isDeaf,
    required this.isMuted,
    required this.channelId,
  });

  Future<void> mute () async {
    Http http = ioc.singleton(Service.http);

    Response response = await http.patch(url: "/guilds/${member.guild.id}/members/${member.user.id}", payload: { 'mute': true });
    if (response.statusCode == 200) {
      isMuted = true;
    }
  }

  Future<void> unmute () async {
    Http http = ioc.singleton(Service.http);

    Response response = await http.patch(url: "/guilds/${member.guild.id}/members/${member.user.id}", payload: { 'mute': false });
    if (response.statusCode == 200) {
      isMuted = false;
    }
  }

  Future<void> deaf () async {
    Http http = ioc.singleton(Service.http);

    Response response = await http.patch(url: "/guilds/${member.guild.id}/members/${member.user.id}", payload: { 'deaf': true });
    if (response.statusCode == 200) {
      isDeaf = true;
    }
  }

  Future<void> undeaf () async {
    Http http = ioc.singleton(Service.http);

    Response response = await http.patch(url: "/guilds/${member.guild.id}/members/${member.user.id}", payload: { 'deaf': false });
    if (response.statusCode == 200) {
      isDeaf = false;
    }
  }

  Future<void> move (VoiceChannel channel) async {
    Http http = ioc.singleton(Service.http);

    Response response = await http.patch(url: "/guilds/${member.guild.id}/members/${member.user.id}", payload: { 'channel_id': channel.id });
    if (response.statusCode == 200) {
      channelId = channel.id;
      this.channel = channel;
    }
  }

  Future<void> disconnect () async {
    Http http = ioc.singleton(Service.http);

    Response response = await http.patch(url: "/guilds/${member.guild.id}/members/${member.user.id}", payload: { 'channel_id': null });
    if (response.statusCode == 200) {
      channelId = null;
      channel = null;
    }
  }

  factory Voice.from ({ required dynamic payload }) {
    return Voice(
      isDeaf: payload['deaf'] == false,
      isMuted: payload['mute'] == false,
      channelId: payload['channel_id'],
    );
  }
}
