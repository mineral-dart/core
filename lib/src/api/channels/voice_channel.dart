import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/channels/permission_overwrite.dart';
import 'package:mineral/src/api/managers/permission_overwrite_manager.dart';
import 'package:mineral/src/api/managers/webhook_manager.dart';

class VoiceChannel extends Channel {
  int? bitrate;
  int? userLimit;
  int? rateLimitPerUser;
  String? rtcRegion;
  int? videoQualityMode;

  VoiceChannel({
    required Snowflake id,
    required Snowflake? guildId,
    required int? position,
    required String label,
    required Snowflake? applicationId,
    required Snowflake? parentId,
    required int? flags,
    required this.bitrate,
    required this.userLimit,
    required this.rateLimitPerUser,
    required this.rtcRegion,
    required this.videoQualityMode,
    required PermissionOverwriteManager permissionOverwrites
  }) : super(
    id: id,
    type: ChannelType.guildVoice,
    guildId: guildId,
    position: position,
    label: label,
    applicationId: applicationId,
    parentId: parentId,
    flags: flags,
    webhooks: WebhookManager(guildId: guildId, channelId: id),
    permissionOverwrites: permissionOverwrites
  );


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
    VoiceChannel channel = VoiceChannel.from(payload);

    // Define deep properties
    channel.guildId = guildId;
    channel.guild = guild;
    channel.parent = channel.parentId != null ? guild?.channels.cache.get<CategoryChannel>(channel.parentId) : null;

    guild?.channels.cache.set(channel.id, channel);
    return channel;
  }

  factory VoiceChannel.from(dynamic payload) {
    final PermissionOverwriteManager permissionOverwriteManager = PermissionOverwriteManager(
        guildId: payload['guild_id'],
        channelId: payload['id']
    );
    for(dynamic element in payload['permission_overwrites']) {
      final PermissionOverwrite overwrite = PermissionOverwrite.from(payload: element);
      permissionOverwriteManager.cache.putIfAbsent(overwrite.id, () => overwrite);
    }

    return VoiceChannel(
      id: payload['id'],
      guildId: payload['guild_id'],
      position: payload['position'],
      label: payload['name'],
      applicationId: payload['application_id'],
      parentId: payload['parent_id'],
      flags: payload['flags'],
      bitrate: payload['bitrate'],
      userLimit: payload['user_limit'] ?? false,
      rateLimitPerUser: payload['rate_limit_per_user'],
      rtcRegion: payload['rtc_region'] ,
      videoQualityMode: payload['video_quality_mode'],
      permissionOverwrites: permissionOverwriteManager
    );
  }
}
