
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:mineral/src/internal/websockets/sharding/shard_message.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

Future<void> shardHandler(SendPort shardPort) async {
  final ReceivePort receivePort = ReceivePort();
  final Stream<dynamic> receiveStream = receivePort.asBroadcastStream();

  final SendPort sendPort = receivePort.sendPort;
  shardPort.send(sendPort);

  final ShardMessage initData = await receiveStream.first;
  final String gatewayURL = initData.data["url"];

  late WebSocket socket;
  late StreamSubscription socketListener;

  Future<void> _connect() async {
    socket = await WebSocket.connect(gatewayURL);
    socketListener = socket.listen((event) {
      final WebsocketResponse message = WebsocketResponse.from(event);
      shardPort.send(ShardMessage(command: ShardCommand.data, data: message));
    });

    socket.handleError((err) => {
      shardPort.send(ShardMessage(command: ShardCommand.error, data: {
        "error": err.toString(),
        "code": socket.closeCode,
        "reason": socket.closeReason
      }))
    });

    socket.done.then((value) => {
      shardPort.send(ShardMessage(command: ShardCommand.disconnected, data: {
        "code": socket.closeCode,
        "reason": socket.closeReason
      }))
    });
  }

  _connect();

  Future<void> disconnect() async {
    await socketListener.cancel();
    await socket.close(1000);
  }

  Future<void> terminate() async {
    await disconnect();
    shardPort.send(ShardMessage(command: ShardCommand.terminateOk));
  }

  await for (final ShardMessage message in receiveStream) {
    switch(message.command) {
      case(ShardCommand.send):
        if(socket.closeCode == null) socket.add(jsonEncode(message.data));
        continue;
      case(ShardCommand.reconnect):
        await disconnect();
        await _connect();
        continue;
      case(ShardCommand.terminate):
        await terminate();
        continue;
      default:
    }
  }
}