import 'dart:convert';

import 'package:mineral/api/wss/websocket_client.dart';
import 'package:mineral/discord/wss/constants/op_code.dart';
import 'package:mineral/discord/wss/discord_payload_message.dart';
import 'package:mineral/discord/wss/discord_websocket_config.dart';
import 'package:mineral/discord/wss/dispatchers/discord_authentication.dart';
import 'package:mineral/discord/wss/dispatchers/discord_event.dart';

abstract interface class WebsocketManager {
  DiscordWebsocketConfig get config;

  WebsocketClient get client;

  DiscordAuthentication get authentication;

  Future<void> init();
}

final class WebsocketManagerImpl implements WebsocketManager {
  @override
  final DiscordWebsocketConfig config;

  @override
  late final WebsocketClient client;

  @override
  late final DiscordAuthentication authentication;

  final String url;

  late final DiscordEvent dispatchEvent;

  WebsocketManagerImpl({required this.url, required this.config}) {
    client = WebsocketClientImpl(
        url: url,
        onClose: () async {
          print('Channel closed');
          authentication.connect();
        },
        onError: (error) => print('Error ! $error'),
        onOpen: (message) => print('Opened ! $message'));

    authentication = DiscordAuthenticationImpl(
      client: client,
      config: config,
    );

    dispatchEvent = DiscordEventImpl(authentication);
  }

  @override
  Future<void> init() async {
    client.interceptor.message.add((message) async {
      message.content = DiscordPayloadMessageImpl.of(jsonDecode(message.originalContent));

      return message;
    });

    client.listen((message) {
      print(message.originalContent);
      if (message.content case DiscordPayloadMessage(opCode: final code, payload: final payload)) {
        switch (code) {
          case OpCode.hello:
            authentication.identify(payload);
          case OpCode.heartbeatAck:
            authentication.ack();
          case OpCode.reconnect:
            authentication.reconnect();
          case OpCode.invalidSession:
            authentication.resume();
          case OpCode.dispatch:
            dispatchEvent.dispatch(message.content);
          default:
            print('Unknown op code ! $code');
        }
      }
    });

    authentication.connect();
  }
}
