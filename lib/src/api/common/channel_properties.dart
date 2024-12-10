import 'package:mineral/src/api/common/channel_permission_overwrite.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/common/types/channel_type.dart';
import 'package:mineral/src/api/private/user.dart';
import 'package:mineral/src/api/server/managers/threads_manager.dart';
import 'package:mineral/src/domains/commons/utils/helper.dart';
import 'package:mineral/src/domains/commons/utils/utils.dart';
import 'package:mineral/src/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/src/infrastructure/internals/datastore/parts/channel_part.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';

final class ChannelProperties {
  ChannelPart get dataStoreChannel => ioc.resolve<DataStoreContract>().channel;

  final Snowflake id;
  final ChannelType type;
  final String? name;
  final String? description;
  final Snowflake? serverId;
  final Snowflake? categoryId;
  final int? position;
  final bool nsfw;
  final Snowflake? lastMessageId;
  final int? bitrate;
  final int? userLimit;
  final int? rateLimitPerUser;
  final List<User> recipients;
  final String? icon;
  final String? ownerId;
  final String? applicationId;
  final String? lastPinTimestamp;
  final String? rtcRegion;
  final int? videoQualityMode;
  final int? messageCount;
  final int? memberCount;
  final int? defaultAutoArchiveDuration;
  final List<ChannelPermissionOverwrite>? permissions;
  final int? flags;
  final int? totalMessageSent;
  final dynamic available;
  final List<Snowflake> appliedTags;
  final dynamic defaultReactions;
  final int? defaultSortOrder;
  final int? defaultForumLayout;
  final ThreadsManager threads;

  ChannelProperties({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.serverId,
    required this.categoryId,
    required this.position,
    required this.nsfw,
    required this.lastMessageId,
    required this.bitrate,
    required this.userLimit,
    required this.rateLimitPerUser,
    required this.recipients,
    required this.icon,
    required this.ownerId,
    required this.applicationId,
    required this.lastPinTimestamp,
    required this.rtcRegion,
    required this.videoQualityMode,
    required this.messageCount,
    required this.memberCount,
    required this.defaultAutoArchiveDuration,
    required this.permissions,
    required this.flags,
    required this.totalMessageSent,
    required this.available,
    required this.appliedTags,
    required this.defaultReactions,
    required this.defaultSortOrder,
    required this.defaultForumLayout,
    required this.threads,
  });

  static Future<ChannelProperties> serializeCache(
      MarshallerContract marshaller, Map<String, dynamic> element) async {
    final permissionOverwrites = await Helper.createOrNullAsync(
        field: element['permission_overwrites'],
        fn: () async => Future.wait(
              List.from(element['permission_overwrites'])
                  .map((json) async => marshaller
                      .serializers.channelPermissionOverwrite
                      .serialize(json))
                  .toList(),
            ));

    final recipients = await Helper.createOrNullAsync(
        field: element['recipients'],
        fn: () async => Future.wait(
              List.from(element['recipients'])
                  .map((json) async =>
                      marshaller.serializers.user.serialize(json))
                  .toList(),
            ));

    return ChannelProperties(
        id: Snowflake(element['id']),
        type: findInEnum(ChannelType.values, element['type']),
        name: element['name'],
        description: element['description'],
        serverId: Helper.createOrNull(
            field: element['server_id'],
            fn: () => Snowflake(element['server_id'])),
        categoryId: Helper.createOrNull(
            field: element['parent_id'],
            fn: () => Snowflake(element['parent_id'])),
        position: element['position'],
        nsfw: element['nsfw'] ?? false,
        lastMessageId: Helper.createOrNull(
            field: element['last_message_id'],
            fn: () => Snowflake(element['last_message_id'])),
        bitrate: element['bitrate'],
        userLimit: element['user_limit'],
        rateLimitPerUser: element['rate_limit_per_user'],
        recipients: recipients ?? [],
        icon: element['icon'],
        ownerId: element['owner_id'],
        applicationId: element['application_id'],
        lastPinTimestamp: element['last_pin_timestamp'],
        rtcRegion: element['rtc_region'],
        videoQualityMode: element['video_quality_mode'],
        messageCount: element['message_count'],
        memberCount: element['member_count'],
        defaultAutoArchiveDuration: element['default_auto_archive_duration'],
        permissions: permissionOverwrites,
        flags: element['flags'],
        totalMessageSent: element['total_message_sent'],
        available: element['available'],
        appliedTags: element['applied_tags'] ?? [],
        defaultReactions: element['default_reactions'],
        defaultSortOrder: element['default_sort_order'],
        defaultForumLayout: element['default_forum_layout'],
        threads: ThreadsManager({}));
  }
}
