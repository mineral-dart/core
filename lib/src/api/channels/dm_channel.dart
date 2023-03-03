import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/managers/dm_user_manager.dart';
import 'package:mineral/src/api/users/dm_user.dart';
import 'package:mineral_ioc/ioc.dart';

class DmChannel extends PartialChannel {
  Snowflake? lastMessageId;
  MessageManager<DmMessage> messages;
  DmUserManager members;

  DmChannel(
    this.lastMessageId,
    this.messages,
    this.members,
    super.id
  );

  factory DmChannel.fromPayload(dynamic payload) {
    final userManager = DmUserManager(payload['id']);

    if (payload['recipients'] != null) {
      for (dynamic element in payload['recipients']) {
        User? user = ioc.use<MineralClient>().users.cache.get(element['id']);

        if (user != null) {
          userManager.cache.putIfAbsent(user.id, () => DmUser.fromUser(user, payload['id']));
        }
      }
    }

    return DmChannel(
      payload['last_message_id'],
      MessageManager(null, payload['id']),
      userManager,
      payload['id'],
    );
  }
}
