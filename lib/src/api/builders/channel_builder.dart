import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';

class ChannelBuilder {
  Map<String, dynamic> payload;
  ChannelBuilder(this.payload);

  factory ChannelBuilder.fromTextChannel ({
    String? label,
    String? description,
    Snowflake? parentId,
    int? position,
    List<PermissionOverwrite>? permissions,
    bool? nsfw,
    int? rateLimitPerUser,
  }) {
    return ChannelBuilder({
      'type': ChannelType.guildText.value,
      'name': label,
      'topic': description,
      'parent_id': parentId,
      'position': position,
      'permission_overwrites': permissions?.map((permission) => permission.toJSON()).toList(),
      'nsfw': nsfw,
      'rate_limit_per_user': rateLimitPerUser
    });
  }

  factory ChannelBuilder.fromCategoryChannel ({ String? label, int? position, List<PermissionOverwrite>? permissions }) {
    return ChannelBuilder({
      'type': ChannelType.guildCategory.value,
      'name': label,
      'position': position,
      'permission_overwrites': permissions?.map((permission) => permission.toJSON()).toList(),
    });
  }

  factory ChannelBuilder.fromVoiceChannel ({
    String? label,
    Snowflake? parentId,
    int? position,
    List<PermissionOverwrite>? permissions,
    bool? nsfw,
    int? bitrate,
    int? userLimit,
    String? rtcRegion,
    int? videoQualityMode,
  }) {
    return ChannelBuilder({
      'type': ChannelType.guildVoice.value,
      'name': label,
      'parent_id': parentId,
      'position': position,
      'permission_overwrites': permissions?.map((permission) => permission.toJSON()).toList(),
      'nsfw': nsfw,
      'bitrate': bitrate,
      'user_limit': userLimit,
      'rtc_region': rtcRegion,
      'video_quality_mode': videoQualityMode
    });
  }

  factory ChannelBuilder.fromForumChannel ({ required String label, String? guidelines, Snowflake? parentId, List<ForumTagBuilder>? tags }) {
    return ChannelBuilder({
      'type': ChannelType.guildForum.value,
      'name': label,
      'parent_id': parentId,
      'topic': guidelines,
      'available_tags': [...?tags?.map((tag) => tag.toJson())],
    });
  }
}
