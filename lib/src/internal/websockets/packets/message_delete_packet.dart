import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/services/event_service.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class MessageDeletePacket with Container implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventService eventService = container.use<EventService>();
    MineralClient client = container.use<MineralClient>();

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    TextBasedChannel? channel = guild?.channels.cache.get(payload['channel_id']);
    Message? message = channel?.messages.cache.get(payload['id']);

    if (channel?.id == null) {
      return;
    }

    if (message == null) {
      Response response = await container.use<HttpService>().get(url: "/channels/${channel?.id}/messages/${payload['id']}");

      if (response.statusCode == 200) {
        dynamic json = jsonDecode(response.body);
        message = Message.from(channel: channel!, payload: json);
      }
    }

    eventService.controller.add(MessageDeleteEvent(message!));
    channel?.messages.cache.remove(payload['id']);
  }
}
