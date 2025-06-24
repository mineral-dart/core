import 'dart:collection';
import 'dart:convert';

import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/services/wss/constants/op_code.dart';
import 'package:mineral/src/domains/services/wss/running_strategy.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/dispatchers/shard_authentication.dart';
import 'package:mineral/src/infrastructure/internals/wss/dispatchers/shard_data.dart';
import 'package:mineral/src/infrastructure/internals/wss/dispatchers/shard_network_error.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/infrastructure/services/wss/websocket_client.dart';
import 'package:mineral/src/infrastructure/services/wss/websocket_message.dart';

final class Shard implements ShardContract {
  @override
  final Queue<Map<String, dynamic>> onceEventQueue = Queue();

  @override
  final String shardName;

  @override
  final WebsocketOrchestratorContract wss;

  @override
  final HmrContract? hmr;

  @override
  late WebsocketClient client;

  @override
  late final ShardAuthentication authentication;

  final String url;

  late final ShardData dispatchEvent;

  late final ShardNetworkError networkError;

  Shard(
      {required this.shardName,
      required this.url,
      required this.wss,
      required this.hmr,
      required RunningStrategy strategy}) {
    authentication = ShardAuthentication(this);
    networkError = ShardNetworkError(this);
    dispatchEvent = ShardData(this, strategy);
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
        onClose: networkError.dispatch,
        onOpen: (message) {
          if (message.content case ShardMessage(:final payload)) {
            logger.trace(jsonEncode(payload));
          }
        });

    client.interceptor.message
      ..add(wss.config.encoding.decode)
      ..add((WebsocketMessage message) {
        logger.trace({'shard': shardName, 'message': message.content.payload});
        return message;
      });

    client.interceptor.request.add(wss.config.encoding.encode);

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
              final decoded = wss.config.encoding.decode(message);
              onceEventQueue.add(decoded.content.serialize());
            }

            dispatchEvent.dispatch(message);
          case OpCode.heartbeat:
            authentication.heartbeat();
          default:
            print('Unknown op code ! $code');
        }
      }
    });

    await authentication.connect();
  }
}
