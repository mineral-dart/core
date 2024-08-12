import 'package:mineral/api/common/channel_permission_overwrite.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_text_channel.dart';
import 'package:mineral/api/server/threads/thread_member.dart';
import 'package:mineral/api/server/threads/thread_metadata.dart';
import 'package:mineral/infrastructure/commons/helper.dart';
import 'package:mineral/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/infrastructure/internals/datastore/parts/channel_part.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';

final class ThreadProperties {
  ChannelPart get dataStoreChannel => ioc.resolve<DataStoreContract>().channel;

  final Snowflake id;
  final ChannelType type;
  final ServerTextChannel? channel;
  final Snowflake? channelId;
  final bool isPublic;
  final int? memberCount;
  final String? name;
  final String? description;
  final Snowflake? guildId;
  final ThreadMember? owner;
  final bool nsfw;
  final Snowflake? lastMessageId;
  final int? bitrate;
  final int? userLimit;
  final int? rateLimitPerUser;
  final List<ThreadMember> members;
  final ThreadMetadata metadata;
  final String? lastPinTimestamp;
  final String? rtcRegion;
  final int? videoQualityMode;
  final int? messageCount;
  final int? defaultAutoArchiveDuration;
  final List<ChannelPermissionOverwrite>? permissions;
  final int? flags;
  final int? totalMessageSent;
  final dynamic available;
  final List<Snowflake> appliedTags;
  final dynamic defaultReactions;
  final int? defaultSortOrder;
  final int? defaultForumLayout;

  ThreadProperties({
    required this.memberCount,
    required this.metadata,
    required this.members,
    required this.id,
    required this.name,
    required this.description,
    required this.guildId,
    required this.nsfw,
    required this.lastMessageId,
    required this.bitrate,
    required this.userLimit,
    required this.rateLimitPerUser,
    required this.owner,
    required this.lastPinTimestamp,
    required this.rtcRegion,
    required this.videoQualityMode,
    required this.messageCount,
    required this.defaultAutoArchiveDuration,
    required this.permissions,
    required this.flags,
    required this.totalMessageSent,
    required this.available,
    required this.appliedTags,
    required this.defaultReactions,
    required this.defaultSortOrder,
    required this.defaultForumLayout,
    required this.isPublic,
    required this.type,
    required this.channel,
    required this.channelId,
  });

  static Future<ThreadProperties> serializeRemote(
      MarshallerContract marshaller, Map<String, dynamic> element) async {
    final ChannelType type = ChannelType.values.firstWhere((e) => e.value == element['type']);
    final permissionOverwrites = await Helper.createOrNullAsync(
        field: element['permission_overwrites'],
        fn: () async => Future.wait(
              List.from(element['permission_overwrites'])
                  .map((json) async =>
                      marshaller.serializers.channelPermissionOverwrite.serializeRemote(json))
                  .toList(),
            ));

    final channel = await marshaller.dataStore.channel.getChannel(Snowflake(element['parent_id']));
    final server = await marshaller.dataStore.server.getServer(Snowflake(element['guild_id']));

    return ThreadProperties(
      id: Snowflake(element['id']),
      name: element['name'],
      description: element['description'],
      guildId: Helper.createOrNull(
          field: element['guild_id'], fn: () => Snowflake(element['guild_id'])),
      channelId: Helper.createOrNull(
          field: element['parent_id'], fn: () => Snowflake(element['parent_id'])),
      nsfw: element['nsfw'] ?? false,
      lastMessageId: Helper.createOrNull(
          field: element['last_message_id'], fn: () => Snowflake(element['last_message_id'])),
      bitrate: element['bitrate'],
      userLimit: element['user_limit'],
      rateLimitPerUser: element['rate_limit_per_user'],
      owner: element['member'] != null ? await ThreadMember.serialize(marshaller, element['member'], server) : null,
      lastPinTimestamp: element['last_pin_timestamp'],
      rtcRegion: element['rtc_region'],
      videoQualityMode: element['video_quality_mode'],
      messageCount: element['message_count'],
      defaultAutoArchiveDuration: element['default_auto_archive_duration'],
      permissions: permissionOverwrites,
      flags: element['flags'],
      totalMessageSent: element['total_message_sent'],
      available: element['available'],
      appliedTags: element['applied_tags'] ?? [],
      defaultReactions: element['default_reactions'],
      defaultSortOrder: element['default_sort_order'],
      defaultForumLayout: element['default_forum_layout'],
      members: [],
      metadata: ThreadMetadata.serialize(element['thread_metadata'], type),
      memberCount: element['member_count'],
      isPublic: type == ChannelType.guildPublicThread,
      type: type,
      channel: channel as ServerTextChannel?,
    );
  }

  static Future<ThreadProperties> serializeCache(
      MarshallerContract marshaller, Map<String, dynamic> element) async {
    final server = await marshaller.dataStore.server.getServer(Snowflake(element['guild_id']));
    final ChannelType type = ChannelType.values.firstWhere((e) => e.value == element['type']);
    final permissionOverwrites = await Helper.createOrNullAsync(
        field: element['permission_overwrites'],
        fn: () async => Future.wait(
          List.from(element['permission_overwrites'])
              .map((json) async =>
              marshaller.serializers.channelPermissionOverwrite.serializeRemote(json))
              .toList(),
        ));
    print("test thread serialize cache");

    final channel = await marshaller.dataStore.channel.getChannel(Snowflake(element['parent_id']));


    return ThreadProperties(
      id: Snowflake(element['id']),
      name: element['name'],
      description: element['description'],
      guildId: Helper.createOrNull(
          field: element['guild_id'], fn: () => Snowflake(element['guild_id'])),
      channelId: Helper.createOrNull(
          field: element['parent_id'], fn: () => Snowflake(element['parent_id'])),
      nsfw: element['nsfw'] ?? false,
      lastMessageId: Helper.createOrNull(
          field: element['last_message_id'], fn: () => Snowflake(element['last_message_id'])),
      bitrate: element['bitrate'],
      userLimit: element['user_limit'],
      rateLimitPerUser: element['rate_limit_per_user'],
      lastPinTimestamp: element['last_pin_timestamp'],
      rtcRegion: element['rtc_region'],
      videoQualityMode: element['video_quality_mode'],
      messageCount: element['message_count'],
      defaultAutoArchiveDuration: element['default_auto_archive_duration'],
      permissions: permissionOverwrites,
      flags: element['flags'],
      totalMessageSent: element['total_message_sent'],
      available: element['available'],
      appliedTags: element['applied_tags'] ?? [],
      defaultReactions: element['default_reactions'],
      defaultSortOrder: element['default_sort_order'],
      defaultForumLayout: element['default_forum_layout'],
      members: [],
      metadata: ThreadMetadata.serialize(element['thread_metadata'], type),
      owner: await ThreadMember.serialize(marshaller, element, server),
      memberCount: element['member_count'],
      isPublic: type == ChannelType.guildPublicThread,
      type: type,
      channel: channel as ServerTextChannel?,
    );
  }
}
