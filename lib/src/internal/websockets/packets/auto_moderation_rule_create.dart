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
    EventManager manager = ioc.singleton(ioc.services.event);
    MineralClient client = ioc.singleton(ioc.services.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    if (guild != null) {
      ModerationRule moderationRule = ModerationRule.from(guild: guild, payload: payload);
      guild.moderationRules.cache.set(moderationRule.id, moderationRule);

      manager.emit(
        event: Events.moderationRuleCreate,
        params: [moderationRule]
      );
    }
  }
}
