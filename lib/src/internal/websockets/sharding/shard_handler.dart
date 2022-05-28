
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:mineral/core.dart';
import 'package:mineral/src/internal/websockets/sharding/shard_message.dart';
import 'package:mineral/src/internal/websockets/websocket_dispatcher.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

Future<void> shardHandler(SendPort shardPort) async {
  final ReceivePort receivePort = ReceivePort();
  final Stream<dynamic> receiveStream = receivePort.asBroadcastStream();

  final SendPort sendPort = receivePort.sendPort;
  shardPort.send(sendPort);

  final ShardMessage initData = await receiveStream.first;
  final String gatewayURL = initData.data["url"];

  //Setup websocket
  final WebsocketDispatcher websocketDispatcher = WebsocketDispatcher();

  WebSocket socket = await WebSocket.connect(gatewayURL);
  socket.listen((event) {
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

  await for (final ShardMessage message in receiveStream) {
    if(message.command == ShardCommand.send) {
      if(socket.closeCode == null) socket.add(jsonEncode(message.data));
      continue;
    }
  }
}