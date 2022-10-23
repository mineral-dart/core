import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class AutoModerationRuleCreate implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.autoModerationRuleCreate;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager manager = ioc.singleton(Service.event);
    MineralClient client = ioc.singleton(Service.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    if (guild != null) {
      ModerationRule? before = guild.moderationRules.cache.get(payload['id']);
      ModerationRule after = ModerationRule.fromPayload(payload);

      manager.emit(
        event: Events.moderationRuleUpdate,
        params: [before, after]
      );

      guild.moderationRules.cache.set(after.id, after);
    }
  }
}
