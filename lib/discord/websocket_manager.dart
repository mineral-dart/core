import 'dart:convert';

import 'package:mineral/api/wss/websocket_client.dart';
import 'package:mineral/discord/discord_payload_message.dart';

abstract interface class WebsocketManager {
  WebsocketClient get client;

  Future<void> init();
}

final class WebsocketManagerImpl implements WebsocketManager {
  @override
  final WebsocketClient client;

  final String url;

  WebsocketManagerImpl({required this.url})
      : client = WebsocketClientImpl(url: url);

  @override
  Future<void> init() async {
    client.interceptor.message.add((message) async {
      message.content =
          DiscordPayloadMessageImpl.of(jsonDecode(message.originalContent));

      return message;
    });

    client.listen((message) {
      if (message.content case DiscordPayloadMessage(payload: final p)) {
      }
    });

    await client.connect();
  }
}
