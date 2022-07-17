import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/channels/permission_overwrite.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class PermissionOverwriteManager implements CacheManager<PermissionOverwrite> {
  @override
  Map<Snowflake, PermissionOverwrite> cache = {};

  Snowflake? guildId;
  Snowflake? channelId;

  PermissionOverwriteManager({required this.guildId, required this.channelId});

  //TODO: Need channel sync
  @override
  Future<Map<Snowflake, PermissionOverwrite>> sync() async {
    throw UnimplementedError();
  }

  Future<void> set (List<PermissionOverwrite> permissionsOverwrite) async {
    final MineralClient client = ioc.singleton(ioc.services.client);
    final Guild guild = client.guilds.cache.getOrFail(guildId);
    final dynamic channel = guild.channels.cache.getOrFail(channelId);

    if(channel is VoiceChannel || channel is TextBasedChannel || channel is CategoryChannel) {
      await channel.update(permissionsOverwrite: permissionsOverwrite);
    }
  }
}
