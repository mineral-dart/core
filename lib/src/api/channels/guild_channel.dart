import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/console.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/permission_overwrite_manager.dart';

class GuildChannel extends PartialChannel {
  final Snowflake _guildId;
  final Snowflake? _parentId;
  final String _label;
  final int _type;
  final int? _position;
  final int? _flags;
  final PermissionOverwriteManager? _permissions;

  GuildChannel(this._guildId, this._parentId, this._label, this._type, this._position, this._flags, this._permissions, super.id);

  /// Get [Guild] from [Ioc]
  Guild get guild => ioc.singleton<MineralClient>(Service.client).guilds.cache.getOrFail(_guildId);

  /// Get [CategoryChannel] or [TextChannel] parent
  GuildChannel? get parent => guild.channels.cache.get(_parentId);

  /// Get [GuildChannel] label
  String get label => _label;

  /// Get [GuildChannel] type
  ChannelType get type => ChannelType.values.firstWhere((element) => element.value == _type);

  /// Get [GuildChannel] permission
  int? get position => _position;

  /// Get [List] of [Flag]
  List<Flag> get flags => _flags != null ? _getFlagsFromBitfield(_flags!) : [];

  /// Get [PermissionOverwrite] manager
  PermissionOverwriteManager? get permissions => _permissions;

  Future<void> setLabel (String value) async {
    await update(ChannelBuilder({ 'name': value }));
  }

  Future<void> setParentId (Snowflake id) async {
    await update(ChannelBuilder({ 'parent_id': id }));
  }

  Future<void> setParent (CategoryChannel channel) async {
    await update(ChannelBuilder({ 'parent_id': channel.id }));
  }

  Future<void> setPermissionsOverwrite (List<PermissionOverwrite> permissions) async {
    await update(ChannelBuilder({ 'permission_overwrites': permissions }));
  }

  Future<void> update (ChannelBuilder builder) async {
    if (_validate()) {
      Http http = ioc.singleton(Service.http);
      await http.patch(url: '/channels/$id', payload: builder.payload);
    }
  }

  /// Deletes this
  ///
  /// ```dart
  /// final GuildChannel channel = guild.channels.cache.getOrFail('240561194958716924');
  /// await channel.delete()
  /// ```
  Future<bool> delete () async {
    Http http = ioc.singleton(Service.http);
    Response response = await http.destroy(url: '/channels/$id');

    guild.channels.cache.remove(this);
    return response.statusCode == 200;
  }

  List<Flag> _getFlagsFromBitfield (int bitfield) {
    List<Flag> flags = [];
    for (Flag element in Flag.values) {
      if ((bitfield & element.value) == element.value) {
        flags.add(element);
      }
    }
    return flags;
  }

  bool _validate () {
    if (type == ChannelType.guildCategory) {
      Console.warn(message: 'A category channel cannot have a parent');
      return false;
    }

    if (type == ChannelType.guildPublicThread || type == ChannelType.private || type == ChannelType.guildNewsThread) {
      Console.warn(message: 'A thread channel cannot change a parent');
      return false;
    }

    return true;
  }
}

enum Flag {
  pinned(1 << 1);

  final int value;
  const Flag(this.value);
}
