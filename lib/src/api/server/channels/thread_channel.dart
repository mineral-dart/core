import 'package:mineral/src/api/common/channel_methods.dart';
import 'package:mineral/src/api/common/channel_permission_overwrite.dart';
import 'package:mineral/src/api/common/components/message_component.dart';
import 'package:mineral/src/api/common/embed/message_embed.dart';
import 'package:mineral/src/api/common/managers/message_manager.dart';
import 'package:mineral/src/api/common/polls/poll.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/common/types/channel_type.dart';
import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/api/server/channels/server_text_channel.dart';
import 'package:mineral/src/api/server/managers/threads_manager.dart';
import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/api/server/server_message.dart';
import 'package:mineral/src/api/server/threads/thread_metadata.dart';

class ThreadChannel extends ServerChannel {
  late final ChannelMethods _methods;

  final MessageManager<ServerMessage> messages = MessageManager();

  @override
  final ChannelType type = ChannelType.guildPrivateThread;

  @override
  final Snowflake id;

  @override
  final String name;

  @override
  final Snowflake serverId;

  final String channelId;

  final ThreadMetadata metadata;

  int get memberCount => members.length;

  final String? lastMessageId;

  final int rateLimitPerUser;

  final DateTime? lastPinTimestamp;

  final int messageCount;

  final int flags;

  final String ownerId;

  @override
  final int position = 0;

  @override
  final List<ChannelPermissionOverwrite> permissions;

  @override
  ThreadsManager threads = ThreadsManager({});

  @override
  late final Server server;

  late final ServerTextChannel parentChannel;

  late final Map<Snowflake, Member> members;

  late final Member owner;

  ThreadChannel({
    required this.id,
    required this.name,
    required this.serverId,
    required this.channelId,
    required this.metadata,
    required this.lastMessageId,
    required this.rateLimitPerUser,
    required this.lastPinTimestamp,
    required this.messageCount,
    required this.flags,
    required this.ownerId,
    required this.permissions,
  }) {
    _methods = ChannelMethods(id);
  }

  Future<void> setName(String name, {String? reason}) =>
      _methods.setName(name, reason);

  Future<void> setDescription(String description, {String? reason}) =>
      _methods.setDescription(description, reason);

  Future<void> setRateLimitPerUser(int rateLimitPerUser, {String? reason}) =>
      _methods.setRateLimitPerUser(rateLimitPerUser, reason);

  Future<void> setDefaultAutoArchiveDuration(int defaultAutoArchiveDuration,
          {String? reason}) =>
      _methods.setDefaultAutoArchiveDuration(
          defaultAutoArchiveDuration, reason);

  Future<void> setDefaultThreadRateLimitPerUser(int value, {String? reason}) =>
      _methods.setDefaultThreadRateLimitPerUser(value, reason);

  Future<void> send(
          {String? content,
          List<MessageEmbed>? embeds,
          Poll? poll,
          List<MessageComponent>? components}) =>
      _methods.send(
          guildId: serverId,
          content: content,
          embeds: embeds,
          poll: poll,
          components: components);

  Future<void> delete({String? reason}) => _methods.delete(reason);
}
