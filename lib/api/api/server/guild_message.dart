import 'package:mineral/api/api/common/message.dart';
import 'package:mineral/api/api/server/channels/guild_channel.dart';
import 'package:mineral/api/api/server/guild_member.dart';

final class GuildMessage implements Message {
  @override
  final String id;

  @override
  final String content;

  @override
  final String createdAt;

  @override
  final String updatedAt;

  @override
  final String channelId;

  @override
  final GuildChannel channel;

  final String userId;

  final GuildMember member;

  GuildMessage({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.channelId,
    required this.channel,
    required this.userId,
    required this.member,
  });
}
