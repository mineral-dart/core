import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';

import 'package:mineral/src/api/server/moderation/action_metadata.dart';
import 'package:mineral/src/api/server/moderation/enums/action_type.dart';
import 'package:mineral/src/domains/commons/utils/utils.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class AutomoderationRuleExecutionPacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.autoModerationRuleExecution;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final serverId = Snowflake.parse(message.payload['guild_id']);
    final server = await _dataStore.server.get(serverId.value, false);

    final memberId = Snowflake.parse(message.payload['user_id']);
    final member = await _dataStore.member.get(serverId.value, memberId.value, false);

    final ruleId = Snowflake.parse(message.payload['rule_id']);
    final channelId = Snowflake.parse(message.payload['channel_id']);
    final messageId = Snowflake.parse(message.payload['message_id']);

    final triggerType = message.payload['trigger_type'];
    final content = message.payload['content'];
    final matchedContent = message.payload['matched_content'];
    final matchedKeyword = message.payload['matched_keyword'];

    final action = Action(
        type: findInEnum(ActionType.values, message.payload['action']['type']),
        metadata: ActionMetadata.fromJson(message.payload['action']['metadata']));

    final ruleExecution = RuleExecution(
      ruleId: ruleId,
      channelId: channelId,
      messageId: messageId,
      server: server,
      member: member!,
      action: action,
      triggerType: triggerType,
      content: content,
      matchedContent: matchedContent,
      matchedKeyword: matchedKeyword,
    );

    dispatch(event: Event.serverRuleExecution, params: [ruleExecution]);
  }
}
