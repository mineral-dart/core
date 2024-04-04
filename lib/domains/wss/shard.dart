import 'dart:collection';
import 'dart:convert';

import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/application/wss/websocket_client.dart';
import 'package:mineral/application/wss/websocket_message.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/shared/types/kernel_contract.dart';
import 'package:mineral/domains/wss/constants/op_code.dart';
import 'package:mineral/domains/wss/dispatchers/shard_authentication.dart';
import 'package:mineral/domains/wss/dispatchers/shard_data.dart';
import 'package:mineral/domains/wss/dispatchers/shard_network_error.dart';
import 'package:mineral/domains/wss/shard_message.dart';

abstract interface class ShardContract {
  Queue<Map<String, dynamic>> get onceEventQueue;

  String get shardName;

  KernelContract get kernel;

  abstract WebsocketClient client;

  ShardAuthentication get authentication;

  Future<void> init();
}

final class Shard implements ShardContract {
  @override
  final Queue<Map<String, dynamic>> onceEventQueue = Queue();

  @override
  final String shardName;

  @override
  final KernelContract kernel;

  @override
  late WebsocketClient client;

  @override
  late final ShardAuthentication authentication;

  final String url;

  late final ShardData dispatchEvent;

  late final ShardNetworkError networkError;

  Shard({required this.shardName, required this.url, required this.kernel}) {
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
        },
        onOpen: (message) {
          if (message.content case ShardMessage(:final payload)) {
            Logger.singleton().trace(jsonEncode(payload));
          }
        });

    client.interceptor.message
      ..add((WebsocketMessage message) async {
        Logger.singleton().trace({
          'shard': shardName,
          'message': message.content,
        });

        return message;
      })
      ..add((message) async {
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
            if ([PacketType.ready.name, PacketType.guildCreate.name].contains((message.content as ShardMessage).type)) {
              onceEventQueue.add(jsonDecode(message.originalContent));
            }

            dispatchEvent.dispatch(message);
          default:
            print('Unknown op code ! $code');
        }
      }
    });

    authentication.connect();
  }
}
