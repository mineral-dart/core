import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/channels/base_channel.dart';
import 'package:mineral/src/api/managers/message_manager.dart';

class DmChannel extends BaseChannel {
  Snowflake? lastMessageId;
  MessageManager messages;
  Map<Snowflake, User> recipients;

  DmChannel({
    required id,
    required this.lastMessageId,
    required this.messages,
    required this.recipients,
  }): super(id: id);

  factory DmChannel.from({ required dynamic payload }) {
    MineralClient client = ioc.singleton(ioc.services.client);

    Map<Snowflake, User> users = {};
    if (payload['recipients'] != null) {
      for (dynamic element in payload['recipients']) {
        User? user = client.users.cache.get(element['id']);
        user ??= User.from(element);

        users.putIfAbsent(user.id, () => user!);
      }
    }

    return DmChannel(
      id: payload['id'],
      lastMessageId: payload['last_message_id'],
      messages: MessageManager(payload['id'], null),
      recipients: users
    );
  }
}
