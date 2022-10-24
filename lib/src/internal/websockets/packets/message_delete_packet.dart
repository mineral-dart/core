import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/event.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class MessageDeletePacket implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager eventManager = ioc.singleton(Service.event);
    MineralClient client = ioc.singleton(Service.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    TextBasedChannel? channel = guild?.channels.cache.get(payload['channel_id']);
    Message? message = channel?.messages.cache.get(payload['id']);

    if (message == null) {
      Http http = ioc.singleton(Service.http);
      Response response = await http.get(url: "/channels/${channel?.id}/messages/${payload['id']}");

      if (response.statusCode == 200) {
        dynamic json = jsonDecode(response.body);
        message = Message.from(channel: channel!, payload: json);
      }
    }

    eventManager.controller.add(MessageDeleteEvent(message!));
    channel?.messages.cache.remove(payload['id']);
  }
}