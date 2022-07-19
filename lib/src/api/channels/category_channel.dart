import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/channels/permission_overwrite.dart';
import 'package:mineral/src/api/managers/permission_overwrite_manager.dart';
import 'package:mineral/src/api/managers/webhook_manager.dart';

class CategoryChannel extends Channel {
  CategoryChannel({
    required Snowflake id,
    required Snowflake? guildId,
    required int? position,
    required String label,
    required Snowflake? applicationId,
    required int? flags,
    required PermissionOverwriteManager permissionOverwrites
  }) : super(
    id: id,
    guildId: guildId,
    position: position,
    label: label,
    applicationId: applicationId,
    parentId: null,
    type: ChannelType.guildCategory,
    flags: flags,
    webhooks: WebhookManager(guildId: guildId, channelId: id),
    permissionOverwrites: permissionOverwrites
  );

  Future<CategoryChannel?> update ({ String? label, int? position, List<PermissionOverwrite>? permissionOverwrites }) async {
    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.patch(url: "/channels/$id", payload: {
      'name': label,
      'position': position,
      'permission_overwrites': permissionOverwrites?.map((e) => e.toJSON()),
    });

    dynamic payload = jsonDecode(response.body);
    CategoryChannel channel = CategoryChannel.from(payload);

    // Define deep properties
    channel.guildId = guildId;
    channel.guild = guild;
    channel.parent = channel.parentId != null ? guild?.channels.cache.get<CategoryChannel>(channel.parentId) : null;

    guild?.channels.cache.set(channel.id, channel);
    return channel;
  }

  Future<bool> delete () async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.destroy(url: "/channels/$id");

    guild?.channels.cache.remove(id);

    return response.statusCode == 200;
  }

  factory CategoryChannel.from(dynamic payload) {
    final PermissionOverwriteManager permissionOverwriteManager = PermissionOverwriteManager(
        guildId: payload['guild_id'],
        channelId: payload['id']
    );
    for(dynamic element in payload['permission_overwrites']) {
      final PermissionOverwrite overwrite = PermissionOverwrite.from(payload: element);
      permissionOverwriteManager.cache.putIfAbsent(overwrite.id, () => overwrite);
    }

    return CategoryChannel(
      id: payload['id'],
      guildId: payload['guild_id'],
      position: payload['position'],
      label: payload['name'],
      applicationId: payload['application_id'],
      flags: payload['flags'],
      permissionOverwrites: permissionOverwriteManager
    );
  }
}
