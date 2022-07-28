import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/channels/partial_channel.dart';
import 'package:mineral/src/api/managers/webhook_manager.dart';
import 'package:mineral/src/api/managers/permission_overwrite_manager.dart';

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

Map<ChannelType, Channel Function(Guild? guild, dynamic payload)> channels = {
  ChannelType.guildText: (Guild? guild, dynamic payload) => TextChannel.from(guild, payload),
  // 'DM': () => ,
  ChannelType.guildVoice: (Guild? guild, dynamic payload) => VoiceChannel.from(guild, payload),
  // 'GROUP_DM': () => ,
  ChannelType.guildCategory: (Guild? guild, dynamic payload) => CategoryChannel.from(guild, payload),
  // 'GUILD_NEWS': () => ,
  // 'GUILD_NEWS_THREAD': () => ,
  // 'GUILD_PUBLIC_THREAD': () => ,
  // 'GUILD_PRIVATE_THREAD': () => ,
  // 'GUILD_STAGE_VOICE': () => ,
  // 'GUILD_DIRECTORY': () => ,
  // 'GUILD_FORUM': () => ,
};

class Channel extends PartialChannel {
  final Guild? _guild;
  late Channel? parent;

  final ChannelType _type;
  int? _position;
  String? _label;
  final Snowflake? _applicationId;
  final int? _flags;
  final WebhookManager? _webhooks;
  final PermissionOverwriteManager? _permissionOverwrites;

  Channel(
    super.id,
    this._type,
    this._position,
    this._label,
    this._applicationId,
    this._flags,
    this._webhooks,
    this._permissionOverwrites,
    this._guild,
  );

  ChannelType get type => _type;
  Guild? get guild => _guild;
  int? get position => _position;
  String? get label => _label;
  Snowflake? get applicationId => _applicationId;
  int? get flags => _flags;
  WebhookManager? get webhooks => _webhooks;
  PermissionOverwriteManager? get permissionOverwrites => _permissionOverwrites;

  Future<T> setLabel<T extends Channel> (String label) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/channels/$id", payload: { 'label': label });

    if (response.statusCode == 200) {
      _label = label;
    }

    return this as T;
  }

  Future<T> setPosition<T extends Channel> (int position) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/channels/$id", payload: { 'position': position });

    if (response.statusCode == 200) {
      _position = position;
    }

    return this as T;
  }

  Future<T> setParent<T extends Channel> (CategoryChannel channel) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/channels/$id", payload: { 'parent_id': channel.id });

    if (response.statusCode == 200) {
      parent = channel;
    }

    return this as T;
  }

  Future<bool> delete () async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.destroy(url: "/channels/$id");

    guild?.channels.cache.remove(id);

    return response.statusCode == 200;
  }

  @override
  String toString () => "<#$id>";
}
