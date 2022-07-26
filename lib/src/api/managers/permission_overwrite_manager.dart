import 'package:mineral/api.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class PermissionOverwriteManager extends CacheManager<PermissionOverwrite> {
  late final Channel channel;

  //TODO: Need channel sync
  Future<Map<Snowflake, PermissionOverwrite>> sync() async {
    throw UnimplementedError();
  }

  /// ### Set [PermissionOverwrite] of a [Channel]
  ///
  /// Example :
  /// ```dart
  /// final TextChannel channel = guild.channels.cache.get('240561194958716924');
  /// final List<PermissionOverwrite> overwrites = [
  ///   PermissionOverwrite(
  ///     id: '240561194958716928',
  ///     type: PermissionOverwriteType.member,
  ///     allow: [Permission.viewChannel, Permission.sendMessages],
  ///     deny: []
  ///   ),
  ///   PermissionOverwrite(
  ///     id: '987741097889517643',
  ///     type: PermissionOverwriteType.role,
  ///     allow: [],
  ///     deny: [Permission.viewChannel]
  ///   )
  /// ];
  /// await channel.permissionOverwrites.set(overwrites);
  /// ```
  Future<void> set (List<PermissionOverwrite> permissionOverwrites) async {
    if(channel is VoiceChannel || channel is TextBasedChannel || channel is CategoryChannel) {
      await (channel as dynamic).update(permissionOverwrites: permissionOverwrites);
    }
  }

  /// ### Add a [PermissionOverwrite] to a [Channel]
  ///
  /// Example :
  /// ```dart
  /// final TextChannel channel = guild.channels.cache.get('240561194958716924');
  /// await channel.permissionOverwrites.add(PermissionOverwrite(
  ///   id: '240561194958716928',
  ///   type: PermissionOverwriteType.member,
  ///   allow: [],
  ///   deny: [Permission.banMembers]
  /// ));
  /// ```
  Future<void> add (PermissionOverwrite permissionOverwrite) async {
    cache.putIfAbsent(permissionOverwrite.id, () => permissionOverwrite);

    if(channel is VoiceChannel || channel is TextBasedChannel || channel is CategoryChannel) {
      await (channel as dynamic).update(permissionOverwrites: cache.values.toList());
    }
  }
}
