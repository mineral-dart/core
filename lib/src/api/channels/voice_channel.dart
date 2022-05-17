part of api;

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
  }) : super(
    id: id,
    type: ChannelType.guildVoice,
    guildId: guildId,
    position: position,
    label: label,
    applicationId: applicationId,
    parentId: parentId,
    flags: flags,
  );

  factory VoiceChannel.from(dynamic payload) {
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
      videoQualityMode: payload['video_quality_mode']
    );
  }
}
