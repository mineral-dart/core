import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class MessageDelete implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.messageDelete;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager manager = ioc.singleton(ioc.services.event);
    MineralClient client = ioc.singleton(ioc.services.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    TextBasedChannel? channel = guild?.channels.cache.get(payload['channel_id']);
    Message? message = channel?.messages.cache.get(payload['id']);

    if (message == null) {
      Http http = ioc.singleton(ioc.services.http);
      Response response = await http.get(url: "/channels/${channel?.id}/messages/${payload['id']}");

      if (response.statusCode == 200) {
        dynamic json = jsonDecode(response.body);
        message = Message.from(channel: channel!, payload: json);
      }
    }

    manager.emit(
      event: Events.messageDelete,
      params: [message]
    );

    channel?.messages.cache.remove(payload['id']);
  }
}
