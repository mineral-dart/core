import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';

import 'package:mineral/src/api/server/moderation/action_metadata.dart';
import 'package:mineral/src/api/server/moderation/enums/action_type.dart';
import 'package:mineral/src/api/server/moderation/enums/trigger_type.dart';
import 'package:mineral/src/domains/common/utils/helper.dart';
import 'package:mineral/src/domains/common/utils/utils.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class AutomoderationActionExecutionPacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.autoModerationActionExecution;

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await _dataStore.server.get(message.payload['guild_id'], false);
    final member = await _dataStore.member.get(message.payload['guild_id'], message.payload['user_id'], false);

    final triggerType = findInEnum(TriggerType.values, message.payload['rule_trigger_type']);

    final action = Action(
        type: findInEnum(ActionType.values, message.payload['action']['type']),
        metadata: Helper.createOrNull(field: message.payload['metadata'], fn: () => ActionMetadata.fromJson(message.payload['metadata'])));

    final ruleExecution = RuleExecution(
      ruleId: Snowflake.parse(message.payload['rule_id']),
      channelId: Snowflake.parse(message.payload['channel_id']),
      messageId: Snowflake.nullable(message.payload['message_id']),
      server: server,
      member: member!,
      action: action,
      triggerType: triggerType,
      content: message.payload['content'],
      matchedContent: message.payload['matched_content'],
      matchedKeyword: message.payload['matched_keyword'],
    );

    dispatch(event: Event.serverRuleExecution, params: [ruleExecution]);
  }
}
