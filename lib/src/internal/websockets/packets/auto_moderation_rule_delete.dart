import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/event.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class AutoModerationRuleDelete implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager manager = ioc.singleton(Service.event);
    MineralClient client = ioc.singleton(Service.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    ModerationRule? moderationRule = guild?.moderationRules.cache.get(payload['id']);

    if (moderationRule != null) {
      manager.controller.add(ModerationRulesDeleteEvent(moderationRule));
      guild?.moderationRules.cache.remove(moderationRule.id);
    }
  }
}
