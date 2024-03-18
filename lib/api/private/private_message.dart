import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/message.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/user.dart';
final class PrivateMessage extends Message<PrivateChannel> {
  final String userId;

  final User user;

  PrivateMessage({
    required Snowflake id,
    required String content,
    required DateTime createdAt,
    required List<MessageEmbed> embeds,
    required DateTime? updatedAt,
    required PrivateChannel channel,
    required this.userId,
    required this.user,
  }) : super(
          id,
          content,
          channel,
          embeds,
          createdAt,
          updatedAt,
        );
}
