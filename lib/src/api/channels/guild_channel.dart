import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/channels/text_channel.dart';
import 'package:mineral/src/api/managers/permission_overwrite_manager.dart';

class GuildChannel<T extends PartialChannel> extends PartialChannel {
  final Snowflake _guildId;
  final Snowflake? _parentId;
  final String _label;
  final int _type;
  final int? _position;
  final int? _flags;
  final PermissionOverwriteManager? _permissions;

  GuildChannel(this._guildId, this._parentId, this._label, this._type, this._position, this._flags, this._permissions, super.id);

  /// Get [Guild] from [Ioc]
  Guild get guild => ioc.singleton<MineralClient>(ioc.services.client).guilds.cache.getOrFail(_guildId);

  /// Get [CategoryChannel] or [TextChannel] parent
  T get parent => guild.channels.cache.get(_parentId);

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

  List<Flag> _getFlagsFromBitfield (int bitfield) {
    List<Flag> flags = [];
    for (Flag element in Flag.values) {
      if ((bitfield & element.value) == element.value) {
        flags.add(element);
      }
    }
    return flags;
  }
}

enum Flag {
  pinned(1 << 1);

  final int value;
  const Flag(this.value);
}
