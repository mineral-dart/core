import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/managers/message_manager.dart';
import 'package:mineral_ioc/ioc.dart';

class DmChannel extends PartialChannel {
  Snowflake? lastMessageId;
  MessageManager messages;
  Map<Snowflake, User> recipients;

  DmChannel(
    this.lastMessageId,
    this.messages,
    this.recipients,
    super.id
  );

  factory DmChannel.fromPayload(dynamic payload) {
    Map<Snowflake, User> users = {};
    if (payload['recipients'] != null) {
      for (dynamic element in payload['recipients']) {
        User? user = ioc.use<MineralClient>().users.cache.get(element['id']);
        user ??= User.from(element);

        users.putIfAbsent(user.id, () => user!);
      }
    }

    return DmChannel(
      payload['last_message_id'],
      MessageManager(),
      users,
      payload['id'],
    );
  }
}
