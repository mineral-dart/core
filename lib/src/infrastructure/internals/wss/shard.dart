import 'dart:collection';
import 'dart:convert';

import 'package:mineral/src/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/constants/op_code.dart';
import 'package:mineral/src/infrastructure/internals/wss/dispatchers/shard_authentication.dart';
import 'package:mineral/src/infrastructure/internals/wss/dispatchers/shard_data.dart';
import 'package:mineral/src/infrastructure/internals/wss/dispatchers/shard_network_error.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/infrastructure/kernel/kernel.dart';
import 'package:mineral/src/infrastructure/services/logger/logger.dart';
import 'package:mineral/src/infrastructure/services/wss/websocket_client.dart';
import 'package:mineral/src/infrastructure/services/wss/websocket_message.dart';

abstract interface class ShardContract {
  Queue<Map<String, dynamic>> get onceEventQueue;

  String get shardName;

  KernelContract get kernel;

  WebsocketClient get client;

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
    final logger = ioc.resolve<LoggerContract>();
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
            logger.trace(jsonEncode(payload));
          }
        });

    client.interceptor.message
      ..add((WebsocketMessage message) async {
        logger.trace({
          'shard': shardName,
          'message': message.content,
        });

        return message;
      })
      ..add((message) async {
        message.content =
            ShardMessageImpl.of(jsonDecode(message.originalContent));
        return message;
      });

    client.listen((message) {
      if (message.content
          case ShardMessage(opCode: final code, payload: final payload)) {
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
            if ([PacketType.ready.name, PacketType.guildCreate.name]
                .contains((message.content as ShardMessage).type)) {
              onceEventQueue.add(jsonDecode(message.originalContent));
            }

            print(json.encode((message.content as ShardMessage).payload));


            dispatchEvent.dispatch(message);
          case OpCode.heartbeat:
            authentication.heartbeat();
          default:
            print('Unknown op code ! $code');

            // Unknown op code ! OpCode.heartbeat
            print(message.originalContent);
        }
      }
    });

    authentication.connect();
  }
}
