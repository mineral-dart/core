import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/commons/utils/helper.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class AutoModerationRuleUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.autoModerationRuleUpdate;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final ruleId = Snowflake.parse(message.payload['id']);
    final ruleCacheKey = _marshaller.cacheKey.serverRules(message.payload['guild_id'], ruleId.value);
    final rawBeforeRule = await _marshaller.cache?.get(ruleCacheKey);
    final before = await Helper.createOrNullAsync<AutoModerationRule>(field: rawBeforeRule, fn: () async => await _marshaller.serializers.rules.serialize(rawBeforeRule!));

    final rawAfterRule = await _marshaller.serializers.rules.normalize(message.payload);
    final after = await _marshaller.serializers.rules.serialize(rawAfterRule);

    dispatch(event: Event.serverRuleUpdate, params: [before, after]);
  }
}
