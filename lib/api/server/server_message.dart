import 'package:mineral/api/common/message.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/channels/server_text_channel.dart';
import 'package:mineral/api/server/member.dart';

final class GuildMessage extends Message<ServerChannel> {
  final String userId;

  final Member member;

  GuildMessage({
    required String id,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
    required ServerChannel channel,
    required this.userId,
    required this.member,
  }): super(id, content, channel, createdAt, updatedAt);
}
