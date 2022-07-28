import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/permission_overwrite_manager.dart';

class CategoryChannel extends Channel {
  CategoryChannel(
    super._id,
    super._type,
    super.position,
    super.label,
    super.applicationId,
    super.flags,
    super._webhooks,
    super.permissionOverwrites,
    super._guild
  );

  Future<CategoryChannel?> update ({ String? label, int? position, List<PermissionOverwrite>? permissionOverwrites }) async {
    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.patch(url: "/channels/$id", payload: {
      'name': label,
      'position': position,
      'permission_overwrites': permissionOverwrites?.map((e) => e.toJSON()),
    });

    dynamic payload = jsonDecode(response.body);
    CategoryChannel channel = CategoryChannel.from(guild, payload);

    // Define deep properties
    channel.parent = channel.parent != null
      ? guild?.channels.cache.get<CategoryChannel>(payload['parent_id'])
      : null;

    guild?.channels.cache.set(channel.id, channel);
    return channel;
  }

  Future<bool> delete () async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.destroy(url: "/channels/$id");

    guild?.channels.cache.remove(id);

    return response.statusCode == 200;
  }

  factory CategoryChannel.from(Guild? guild, dynamic payload) {
    MineralClient client = ioc.singleton(ioc.services.client);
    final permissionOverwriteManager = PermissionOverwriteManager();

    for(dynamic element in payload['permission_overwrites']) {
      final PermissionOverwrite overwrite = PermissionOverwrite.from(payload: element);
      permissionOverwriteManager.cache.putIfAbsent(overwrite.id, () => overwrite);
    }

    final category = CategoryChannel(
      payload['id'],
      ChannelType.guildCategory,
       payload['position'],
      payload['name'],
      payload['application_id'],
      payload['flags'],
      null,
      permissionOverwriteManager,
      client.guilds.cache.get(payload['guild_id'])
    );

    category.permissionOverwrites?.channel = category;

    return category;
  }
}
