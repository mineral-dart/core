part of api;

class ChannelType {
  static int guildText = 0;
  static int private = 1;
  static int guildVoice = 2;
  static int groupDm = 3;
  static int guildCategory = 4;
  static int guildNews = 5;
  static int guildNewsThread = 10;
  static int guildPublicThread = 11;
  static int guildPrivateThread = 12;
  static int guildStageVoice = 13;
  static int guildDirectory = 14;
  static int guildForum = 15;
}

Map<int, Channel Function(dynamic payload)> channels = {
  ChannelType.guildText: (dynamic payload) => TextChannel.from(payload),
  // 'DM': () => ,
  ChannelType.guildVoice: (dynamic payload) => VoiceChannel.from(payload),
  // 'GROUP_DM': () => ,
  ChannelType.guildCategory: (dynamic payload) => CategoryChannel.from(payload),
  // 'GUILD_NEWS': () => ,
  // 'GUILD_NEWS_THREAD': () => ,
  // 'GUILD_PUBLIC_THREAD': () => ,
  // 'GUILD_PRIVATE_THREAD': () => ,
  // 'GUILD_STAGE_VOICE': () => ,
  // 'GUILD_DIRECTORY': () => ,
  // 'GUILD_FORUM': () => ,
};

class Channel {
  Snowflake id;
  int type;
  Snowflake? guildId;
  late Guild? guild;
  int? position;
  String? label;
  Snowflake? applicationId;
  Snowflake? parentId;
  late CategoryChannel? parent;
  int? flags;

  Channel({
    required this.id,
    required this.type,
    required this.guildId,
    required this.position,
    required this.label,
    required this.applicationId,
    required this.parentId,
    required this.flags,
  });
}
