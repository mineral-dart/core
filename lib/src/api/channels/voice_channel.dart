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


  Future<VoiceChannel?> update ({ String? label, String? description, int? delay, int? position, CategoryChannel? categoryChannel, bool? nsfw }) async {
    Http http = ioc.singleton(Service.http);

    Response response = await http.patch(url: "/channels/$id", payload: {
      'name': label ?? this.label,
      'topic': description,
      'parent_id': categoryChannel?.id,
      'nsfw': nsfw ?? false,
      'rate_limit_per_user': delay ?? 0,
      'permission_overwrites': [],
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
