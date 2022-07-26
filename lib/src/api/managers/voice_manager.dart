import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

class VoiceManager {
  bool _isDeaf;
  bool _isMute;
  bool _isSelfMute;
  bool _isSelfDeaf;
  bool _hasVideo;
  bool? _hasStream;
  VoiceChannel? _channel;
  GuildMember? _member;

  VoiceManager( this._isDeaf, this._isMute, this._isSelfMute, this._isSelfDeaf, this._hasVideo, this._hasStream, this._channel, this._member);

  bool get isDeaf => _isDeaf;
  bool get isMute => _isMute;
  bool get isSelfMute => _isSelfMute;
  bool get isSelfDeaf => _isSelfDeaf;
  bool get hasVideo => _hasVideo;
  bool? get hasStream => _hasStream;
  VoiceChannel? get channel => _channel;
  GuildMember? get member => _member;

  /// ### Mutes or unmute a server member
  ///
  /// Example :
  /// ```dart
  /// final member = guild.members.cache.get('240561194958716924');
  ///
  /// if (member != null) {
  ///   await member.setMute(true);
  /// }
  Future<void> setMute(bool value) async {
    final Http http = ioc.singleton(ioc.services.http);

    final Response response = await http.patch(
      url: '/guilds/${member!.guild.id}/members/${member!.user.id}',
      payload: {'mute': value}
    );

    if (response.statusCode == 204 || response.statusCode == 200) {
      _isMute = value;
    }
  }

  /// ### Deafens or not a server member
  ///
  /// Example :
  /// ```dart
  /// final member = guild.members.cache.get('240561194958716924');
  ///
  /// if (member != null) {
  ///   await member.setDeaf(true);
  /// }
  Future<void> setDeaf(bool value) async {
    final Http http = ioc.singleton(ioc.services.http);
    final Response response = await http.patch(
      url: '/guilds/${member!.guild.id}/members/${member!.user.id}',
      payload: {'deaf': value}
    );

    if (response.statusCode == 204 || response.statusCode == 200) {
      _isDeaf = value;
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
  ///   await member.move(voiceChannel.id);
  /// }
  Future<void> move(Snowflake channelId) async {
    _updateChannel(channelId);
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
  Future<void> disconnect() async {
    _updateChannel(null);
  }

  Future<void> _updateChannel(Snowflake? channelId) async {
    final Http http = ioc.singleton(ioc.services.http);
    final Response response = await http.patch(
      url: '/guilds/${member!.guild.id}/members/${member!.user.id}',
      payload: {'channel_id': channelId}
    );

    if (response.statusCode == 204 || response.statusCode == 200) {
      final VoiceChannel? channel = member!.guild.channels.cache.get(channelId);
      if (channel != null) {
        _channel = channel;
      }
    }
  }

  factory VoiceManager.from(dynamic payload, Guild guild, VoiceChannel? channel) {
    return VoiceManager(
      payload['deaf'] == true,
      payload['mute'] == true,
      payload['self_mute'] == true,
      payload['self_deaf'] == true,
      payload['self_video'] == true,
      payload['self_stream'] == true,
      channel,
      guild.members.cache.get(payload['user']?['id']),
    );
  }
}
