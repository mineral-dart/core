import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/channels/thread_channel.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/threads/thread_metadata.dart';
import 'package:mineral/infrastructure/commons/helper.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';

final class ThreadSerializer implements SerializerContract<ThreadChannel> {
  final MarshallerContract _marshaller;

  ThreadSerializer(this._marshaller);

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final membersIds = List.from(json['members'] ?? [json['owner_id'] as String])
        .map((id) => _marshaller.cacheKey.thread(id))
        .toList();

    final payload = {
      'id': json['id'],
      'type': json['type'],
      'name': json['name'],
      'server_id': json['guild_id'],
      'channel_id': json['parent_id'],
      'metadata': {
        'archived': json['thread_metadata']['archived'],
        'auto_archive_duration': json['thread_metadata']['auto_archive_duration'],
        'locked': json['thread_metadata']['locked'],
        'archive_timestamp': json['thread_metadata']['archive_timestamp'],
        'invitable': json['thread_metadata']['invitable'],
        'is_public': json['thread_metadata']['is_public'] ?? true,
      },
      'members_ids': membersIds,
      'member_count': membersIds.length,
      'last_message_id': json['last_message_id'],
      'rate_limit_per_user': json['rate_limit_per_user'],
      'last_pin_timestamp': json['last_pin_timestamp'],
      'message_count': json['message_count'],
      'flags': json['flags'],
      'owner_id': json['owner_id'],
    };

    final cacheKey = _marshaller.cacheKey.thread(json['id']);
    await _marshaller.cache.put(cacheKey, payload);

    return payload;
  }

  @override
  Future<ThreadChannel> serialize(Map<String, dynamic> json) async {
    final permissionOverwrites = await Helper.createOrNullAsync(
        field: json['permission_overwrites'],
        fn: () async => Future.wait(
              List.from(json['permission_overwrites']).map((json) async => _marshaller.serializers.channelPermissionOverwrite.serialize(json)).toList(),
            ));

    final thread = ThreadChannel(
      id: json['id'],
      name: json['name'],
      serverId: Snowflake(json['server_id']),
      channelId: json['channel_id'],
      metadata: ThreadMetadata(
        archived: json['metadata']['archived'],
        autoArchiveDuration: json['metadata']['auto_archive_duration'],
        locked: json['metadata']['locked'],
        archiveTimestamp: json['metadata']['archive_timestamp'] != null ? DateTime.parse(json['metadata']['archive_timestamp']) : null,
        invitable: json['metadata']['invitable'],
        isPublic: json['metadata']['is_public'],
      ),
      lastMessageId: json['last_message_id'],
      rateLimitPerUser: json['rate_limit_per_user'],
      lastPinTimestamp: Helper.createOrNull(field: json['last_pin_timestamp'], fn: () => DateTime.parse(json['last_pin_timestamp'])),
      messageCount: json['message_count'],
      flags: json['flags'],
      ownerId: json['owner_id'],
      permissions: permissionOverwrites ?? [],
    );

    final owner = await _marshaller.dataStore.member.getMember(serverId: thread.serverId, memberId: Snowflake(thread.ownerId));
    final rawMembers = await _marshaller.cache.getMany(json['members_ids'] as List<String>);

    final membersList = await rawMembers.nonNulls.map((element) async {
      return _marshaller.serializers.member.serialize(element);
    }).wait;

    final members = membersList.fold(<Snowflake, Member>{}, (Map<Snowflake, Member> cc, Member member) {
      cc[member.id] = member;
      return cc;
    });

    thread
      ..owner = owner
      ..members = members;

    return thread;
  }

  @override
  Future<Map<String, dynamic>> deserialize(ThreadChannel channel) async {
    return {
      'id': channel.id.value,
      'type': channel.type.value,
      'name': channel.name,
      'server_id': channel.serverId,
      'owner_id': channel.ownerId,
      'parent_id': channel.channelId,
      'thread_metadata': {
        'archived': channel.metadata.archived,
        'auto_archive_duration': channel.metadata.autoArchiveDuration,
        'locked': channel.metadata.locked,
        'archive_timestamp': channel.metadata.archiveTimestamp?.toIso8601String(),
        'invitable': channel.metadata.invitable,
        'is_public': channel.metadata.isPublic,
      },
      'member_count': channel.memberCount,
      'last_message_id': channel.lastMessageId,
      'rate_limit_per_user': channel.rateLimitPerUser,
      'last_pin_timestamp': channel.lastPinTimestamp?.toIso8601String(),
      'message_count': channel.messageCount,
      'flags': channel.flags,
      'members_ids': channel.members.keys.map((id) => _marshaller.cacheKey.member(channel.serverId, id)).toList(),
    };
  }
}
