import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/permission_overwrite_manager.dart';

class VoiceChannel extends Channel {
  int? _bitrate;
  int? _userLimit;
  int? _rateLimitPerUser;
  String? _rtcRegion;
  int? _videoQualityMode;

  VoiceChannel(
    super.id,
    super._type,
    super._position,
    super._label,
    super._applicationId,
    super._flags,
    super._webhooks,
    super._permissionOverwrites,
    super._guild,
    this._bitrate,
    this._userLimit,
    this._rateLimitPerUser,
    this._rtcRegion,
    this._videoQualityMode,
  );

  int? get bitrate => _bitrate;
  int? get userLimit => _userLimit;
  int? get rateLimitPerUser => _rateLimitPerUser;
  String? get rtcRegion => _rtcRegion;
  int? get videoQualityMode => _videoQualityMode;


  Future<VoiceChannel?> update ({ String? label, String? description, int? delay, int? position, CategoryChannel? categoryChannel, bool? nsfw, List<PermissionOverwrite>? permissionOverwrites }) async {
    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.patch(url: "/channels/$id", payload: {
      'name': label ?? this.label,
      'topic': description,
      'parent_id': categoryChannel?.id,
      'nsfw': nsfw ?? false,
      'rate_limit_per_user': delay ?? 0,
      'permission_overwrites': permissionOverwrites?.map((e) => e.toJSON()),
    });

    dynamic payload = jsonDecode(response.body);
    VoiceChannel channel = VoiceChannel.from(guild, payload);

    // Define deep properties
    channel.parent = payload['parent_id'] != null
      ? guild?.channels.cache.get<CategoryChannel>(payload['parent_id'])
      : null;

    guild?.channels.cache.set(channel.id, channel);
    return channel;
  }

  factory VoiceChannel.from(Guild? guild, dynamic payload) {
    MineralClient client = ioc.singleton(ioc.services.client);
    Guild? guild = client.guilds.cache.get(payload['guild_id']);

    final PermissionOverwriteManager permissionOverwriteManager = PermissionOverwriteManager();
    for(dynamic element in payload['permission_overwrites']) {
      final PermissionOverwrite overwrite = PermissionOverwrite.from(payload: element);
      permissionOverwriteManager.cache.putIfAbsent(overwrite.id, () => overwrite);
    }

    return VoiceChannel(
      payload['id'],
      ChannelType.guildVoice,
      payload['position'],
      payload['name'],
      payload['application_id'],
      payload['flags'],
      null,
      permissionOverwriteManager,
      guild,
      payload['bitrate'],
      payload['user_limit'] ?? false,
      payload['rate_limit_per_user'],
      payload['rtc_region'] ,
      payload['video_quality_mode'],
    );
  }
}
