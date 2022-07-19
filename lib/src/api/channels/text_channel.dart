import 'package:mineral/api.dart';
import 'package:mineral/src/api/channels/permission_overwrite.dart';
import 'package:mineral/src/api/managers/message_manager.dart';
import 'package:mineral/src/api/managers/permission_overwrite_manager.dart';
import 'package:mineral/src/api/managers/thread_manager.dart';

class TextChannel extends TextBasedChannel {
  TextChannel({
    required Snowflake id,
    required Snowflake? guildId,
    required int? position,
    required String label,
    required Snowflake? applicationId,
    required Snowflake? parentId,
    required int? flags,
    required Snowflake? description,
    required bool nsfw,
    required Snowflake? lastMessageId,
    required DateTime? lastPinTimestamp,
    required PermissionOverwriteManager permissionOverwrites
  }) : super(
    id: id,
    guildId: guildId,
    position: position,
    label: label,
    applicationId: applicationId,
    parentId: parentId,
    flags: flags,
    description: description,
    nsfw: nsfw,
    lastMessageId: lastMessageId,
    lastPinTimestamp: lastPinTimestamp,
    messages: MessageManager(id, guildId),
    threads: ThreadManager(guildId: guildId),
    permissionOverwrites: permissionOverwrites
  );

  @override
  Future<TextChannel> setDescription (String description) async {
    return await super.setDescription(description);
  }

  @override
  Future<TextChannel> setNsfw (bool value) async {
    return await super.setNsfw(value);
  }

  @override
  Future<TextChannel?> update ({ String? label, String? description, int? delay, int? position, CategoryChannel? categoryChannel, bool? nsfw, List<PermissionOverwrite>? permissionOverwrites }) async {
    return await super.update(label: label, description: description, delay: delay, position: position, categoryChannel: categoryChannel, nsfw: nsfw, permissionOverwrites: permissionOverwrites);
  }

  factory TextChannel.from(dynamic payload) {
    final PermissionOverwriteManager permissionOverwriteManager = PermissionOverwriteManager(
        guildId: payload['guild_id'],
        channelId: payload['id']
    );
    for(dynamic element in payload['permission_overwrites']) {
      final PermissionOverwrite overwrite = PermissionOverwrite.from(payload: element);
      permissionOverwriteManager.cache.putIfAbsent(overwrite.id, () => overwrite);
    }

    TextChannel channel =  TextChannel(
      id: payload['id'],
      guildId: payload['guild_id'],
      position: payload['position'],
      label: payload['name'],
      applicationId: payload['application_id'],
      parentId: payload['parent_id'],
      flags: payload['flags'],
      description: payload['topic'],
      nsfw: payload['nsfw'] ?? false,
      lastMessageId: payload['last_message_id'],
      lastPinTimestamp: payload['last_pin_timestamp'] != null ? DateTime.parse(payload['last_pin_timestamp']) : null,
      permissionOverwrites: permissionOverwriteManager
    );
    channel.threads.channel = channel;

    return channel;
  }
}
