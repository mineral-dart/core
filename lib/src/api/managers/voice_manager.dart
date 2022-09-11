import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/console.dart';
import 'package:mineral/core.dart';

class VoiceManager {
  bool _isDeaf;
  bool _isMute;
  bool _isSelfMute;
  bool _isSelfDeaf;
  bool _hasVideo;
  bool? _hasStream;
  Snowflake _guildId;
  Snowflake? _channelId;
  Snowflake _memberId;

  VoiceManager( this._isDeaf, this._isMute, this._isSelfMute, this._isSelfDeaf, this._hasVideo, this._hasStream, this._channelId, this._memberId, this._guildId);

  bool get isDeaf => _isDeaf;
  bool get isMute => _isMute;
  bool get isSelfMute => _isSelfMute;
  bool get isSelfDeaf => _isSelfDeaf;
  bool get hasVideo => _hasVideo;
  bool? get hasStream => _hasStream;

  Guild get guild => ioc.singleton<MineralClient>(ioc.services.client).guilds.cache.getOrFail(_guildId);
  VoiceChannel? get channel => guild.channels.cache.get(_channelId);
  GuildMember get member => guild.members.cache.getOrFail(_memberId);

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
      url: '/guilds/$_guildId/members/$_memberId',
      payload: {'mute': value}
    );

    if (response.statusCode == 204 || response.statusCode == 200) {
      _isMute = value;
      return;
    }

    Console.error(message: 'Unable to ${value ? 'mute' : 'unmute'} user #$_memberId');
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
      url: '/guilds/$_guildId/members/$_memberId',
      payload: {'deaf': value}
    );

    if (response.statusCode == 204 || response.statusCode == 200) {
      _isDeaf = value;
      return;
    }

    Console.error(message: 'Unable to ${value ? 'deaf' : 'undeaf'} user #$_memberId');
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
      url: '/guilds/$_guildId/members/$_memberId',
      payload: {'channel_id': channelId}
    );

    if (response.statusCode == 204 || response.statusCode == 200) {
      _channelId = _channelId;
      return;
    }

    Console.error(message: 'Unable to move user $_memberId to $channelId');
  }

  factory VoiceManager.from(dynamic payload, Snowflake guildId) {
    return VoiceManager(
      payload['deaf'] == true,
      payload['mute'] == true,
      payload['self_mute'] == true,
      payload['self_deaf'] == true,
      payload['self_video'] == true,
      payload['self_stream'] == true,
      payload['channel_id'],
      payload['user_id'],
      guildId
    );
  }

  factory VoiceManager.empty(bool deaf, bool mute, Snowflake memberId, Snowflake guildId) {
    return VoiceManager(deaf, mute, false, false, false, false, null, memberId, guildId);
  }
}
