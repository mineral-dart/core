import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

enum ChannelType {
  guildText(0),
  private(1),
  guildVoice(2),
  groupDm(3),
  guildCategory(4),
  guildNews(5),
  guildNewsThread(10),
  guildPublicThread(11),
  guildPrivateThread(12),
  guildStageVoice(13),
  guildDirectory(14),
  guildForum(15);

  final int value;
  const ChannelType(this.value);
}

Map<ChannelType, Channel Function(dynamic payload)> channels = {
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
  ChannelType type;
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
