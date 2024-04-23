import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/emoji.dart';
import 'package:mineral/api/common/message.dart';
import 'package:mineral/api/private/user.dart';
import 'package:mineral/api/server/server.dart';

final class ReactionEmoji<T extends Channel> {
  final Emoji emoji;
  final List<User> users;
  final T? channel;
  late final Message<T> message;
  final Server? server;

  ReactionEmoji({
    required this.emoji,
    required this.users,
    this.server,
    this.channel,
  });

}