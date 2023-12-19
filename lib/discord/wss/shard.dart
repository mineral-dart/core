import 'dart:convert';

import 'package:mineral/api/wss/websocket_client.dart';
import 'package:mineral/discord/process_manager.dart';
import 'package:mineral/discord/wss/constants/op_code.dart';
import 'package:mineral/discord/wss/dispatchers/shard_authentication.dart';
import 'package:mineral/discord/wss/dispatchers/shard_data.dart';
import 'package:mineral/discord/wss/dispatchers/shard_network_error.dart';
import 'package:mineral/discord/wss/shard_message.dart';

abstract interface class Shard {
  String get shardName;

  ProcessManager get manager;

  abstract WebsocketClient client;

  ShardAuthentication get authentication;

  Future<void> init();
}

final class ShardImpl implements Shard {
  @override
  final String shardName;

  @override
  final ProcessManager manager;

  @override
  late WebsocketClient client;

  @override
  late final ShardAuthentication authentication;

  final String url;

  late final ShardData dispatchEvent;

  late final ShardNetworkError networkError;

  ShardImpl({required this.shardName, required this.url, required this.manager}) {
    authentication = ShardAuthenticationImpl(this);
    networkError = ShardNetworkErrorImpl(this);
    dispatchEvent = ShardDataImpl(this);
  }

  @override
  Future<void> init() async {
    client = WebsocketClientImpl(
        name: shardName,
        url: url,
        onError: (error) {
          print('error $error');
          networkError.dispatch(error);
        },
        onClose: (int? exitCode) {
          networkError.dispatch(exitCode);
          print('closed !');
        },
        onOpen: (message) {
          if (message.content case ShardMessage(:final payload)) {
            print('Opened<< ! $payload');
          }
        });

    client.interceptor.message.add((message) async {
      message.content = ShardMessageImpl.of(jsonDecode(message.originalContent));
      return message;
    });

    client.listen((message) {
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
