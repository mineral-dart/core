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

  Future<T> setLabel<T extends Channel> (String label) async {
    Http http = ioc.singleton(Service.http);
    Response response = await http.patch(url: "/channels/$id", payload: { 'label': label });

    if (response.statusCode == 200) {
      this.label = label;
    }

    return this as T;
  }

  Future<T> setPosition<T extends Channel> (int position) async {
    Http http = ioc.singleton(Service.http);
    Response response = await http.patch(url: "/channels/$id", payload: { 'position': position });

    if (response.statusCode == 200) {
      this.position = position;
    }

    return this as T;
  }

  Future<T> setParent<T extends Channel> (CategoryChannel channel) async {
    Http http = ioc.singleton(Service.http);
    Response response = await http.patch(url: "/channels/$id", payload: { 'parent_id': channel.id });

    if (response.statusCode == 200) {
      parentId = channel.id;
      parent = channel;
    }

    return this as T;
  }

  @override
  String toString () => "<#$id>";
}
