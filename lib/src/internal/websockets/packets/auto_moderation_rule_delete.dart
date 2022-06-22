import 'dart:convert';

import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/entities/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class AutoModerationRuleDelete implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.autoModerationRuleDelete;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager manager = ioc.singleton(ioc.services.event);
    MineralClient client = ioc.singleton(ioc.services.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    ModerationRule? moderationRule = guild?.moderationRules.cache.get(payload['id']);

    print(jsonEncode(payload));
    print(guild);
    print(moderationRule);

    if (moderationRule != null) {
      manager.emit(Events.moderationRuleDelete, [moderationRule]);
      guild?.moderationRules.cache.remove(moderationRule.id);
    }
  }
}
