import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/events.dart';

import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/mixins/mineral_client.dart';
import 'package:mineral/src/internal/services/event_service.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

import '../../../../core.dart';

class GuildCreatePacket with Container implements WebsocketPacket  {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventService eventService = container.use<EventService>();
    MineralClient client = container.use<MineralClient>();
    Guild guild = await client.makeGuild(websocketResponse.payload);

    eventService.controller.add(GuildCreateEvent(guild));
  }

  Future<Map<Snowflake, ModerationRule>?> getAutoModerationRules (Guild guild) async {
    Response response = await container.use<DiscordApiHttpService>()
        .get(url: "/guilds/${guild.id}/auto-moderation/rules")
        .build();

    if (response.statusCode == 200) {
      final payload = jsonDecode(response.body);

      Map<Snowflake, ModerationRule> rules = {};
      for (final element in payload) {
        ModerationRule rule = ModerationRule.fromPayload(element);
        rules.putIfAbsent(rule.id, () => rule);
      }

      return rules;
    }

    return null;
  }
}
