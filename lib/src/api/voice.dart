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

  /// ### Mutes a server member
  ///
  /// Example :
  /// ```dart
  /// final member = guild.members.cache.get('240561194958716924');
  ///
  /// if (member != null) {
  ///   await member.mute();
  /// }
  Future<void> mute () async {
    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.patch(url: "/guilds/${member.guild.id}/members/${member.user.id}", payload: { 'mute': true });
    if (response.statusCode == 200) {
      isMuted = true;
    }
  }

  /// ### Remove mutes a server member
  ///
  /// Example :
  /// ```dart
  /// final member = guild.members.cache.get('240561194958716924');
  ///
  /// if (member != null) {
  ///   await member.unmute();
  /// }
  Future<void> unmute () async {
    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.patch(url: "/guilds/${member.guild.id}/members/${member.user.id}", payload: { 'mute': false });
    if (response.statusCode == 200) {
      isMuted = false;
    }
  }

  /// ### Deafens a server member
  ///
  /// Example :
  /// ```dart
  /// final member = guild.members.cache.get('240561194958716924');
  ///
  /// if (member != null) {
  ///   await member.deaf();
  /// }
  Future<void> deaf () async {
    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.patch(url: "/guilds/${member.guild.id}/members/${member.user.id}", payload: { 'deaf': true });
    if (response.statusCode == 200) {
      isDeaf = true;
    }
  }

  /// ### Remove deafens a server member
  ///
  /// Example :
  /// ```dart
  /// final member = guild.members.cache.get('240561194958716924');
  ///
  /// if (member != null) {
  ///   await member.undeaf();
  /// }
  Future<void> undeaf () async {
    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.patch(url: "/guilds/${member.guild.id}/members/${member.user.id}", payload: { 'deaf': false });
    if (response.statusCode == 200) {
      isDeaf = false;
    }
  }

  /// ### Moves a member from one voice channel to another
  ///
  /// Example :
  /// ```dart
  /// final member = guild.members.cache.get('240561194958716924');
  /// final voiceChannel = guild.channels.cache.get('240561194958716924');
  ///
  /// if (member != null && voiceChannel != null) {
  ///   await member.move(voiceChannel);
  /// }
  Future<void> move (VoiceChannel channel) async {
    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.patch(url: "/guilds/${member.guild.id}/members/${member.user.id}", payload: { 'channel_id': channel.id });
    if (response.statusCode == 200) {
      channelId = channel.id;
      this.channel = channel;
    }
  }
  /// ### Disconnects the user from a voice channel
  ///
  /// Example :
  /// ```dart
  /// final member = guild.members.cache.get('240561194958716924');
  ///
  /// if (member != null) {
  ///   await member.disconnect();
  /// }
  Future<void> disconnect () async {
    Http http = ioc.singleton(ioc.services.http);

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
