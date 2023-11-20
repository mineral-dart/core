import 'dart:convert';

import 'package:mineral/api/wss/websocket_client.dart';
import 'package:mineral/discord/wss/constants/op_code.dart';
import 'package:mineral/discord/wss/shard_message.dart';
import 'package:mineral/discord/wss/dispatchers/shard_authentication.dart';
import 'package:mineral/discord/wss/dispatchers/shard_data.dart';
import 'package:mineral/discord/wss/dispatchers/shard_network_error.dart';
import 'package:mineral/discord/wss/sharding_config.dart';

abstract interface class Shard {
  ShardingConfig get config;

  WebsocketClient get client;

  ShardAuthentication get authentication;

  Future<void> init();
}

final class ShardImpl implements Shard {
  @override
  final ShardingConfig config;

  @override
  late final WebsocketClient client;

  @override
  late final ShardAuthentication authentication;

  final String url;

  late final ShardData dispatchEvent;

  late final ShardNetworkError networkError;

  ShardImpl({required String shardName, required this.url, required this.config}) {
    client = WebsocketClientImpl(
        name: shardName,
        url: url,
        onClose: () async {
          authentication.connect();
        },
        onError: (error) => networkError.dispatch(error),
        onOpen: (message) => print('Opened ! $message'));

    authentication = ShardAuthenticationImpl(client, config);
    networkError = ShardNetworkErrorImpl(client, authentication, config);
    dispatchEvent = ShardDataImpl(authentication);
  }

  @override
  Future<void> init() async {
    client.interceptor.message.add((message) async {
      message.content = ShardMessageImpl.of(jsonDecode(message.originalContent));
      return message;
    });

    client.listen((message) {
      print(message.originalContent);
      if (message.content case ShardMessage(opCode: final code, payload: final payload)) {
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
