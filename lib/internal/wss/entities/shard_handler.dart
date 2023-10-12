import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:mineral/internal/wss/builders/shard_message_builder.dart';
import 'package:mineral/internal/wss/entities/websocket_response.dart';
import 'package:mineral/internal/wss/shard_action.dart';
import 'package:mineral/internal/wss/shard_message.dart';

final class ShardHandler {
  final ReceivePort _receivePort = ReceivePort();
  late final String _gatewayUrl;
  late final SendPort _shardPort;
  late final Stream<dynamic> _stream;
  late final WebSocket _socket;
  late StreamSubscription _socketListener;

  ShardHandler() {
    _stream = _receivePort.asBroadcastStream();
  }

  Future<void> handle (SendPort shardPort) async {
    _shardPort = shardPort;
    _shardPort.send(_receivePort.sendPort);

    final initData = await _stream.first;
    _gatewayUrl = initData.data['url'];

    try {
      _connect();
    } catch (error) {
      print(error);

      final message = ShardMessageBuilder()
        .setAction(ShardAction.error)
        .append('reason', error)
        .append('code', _socket.closeCode)
        .build();

      _shardPort.send(message);
    } finally {
    }
  }

  Future<void> _disconnected () async {
    await _socketListener.cancel();
    await _socket.close(4000, 'Shard disconnected');
  }

  Future<void> _terminate() async {
    await _disconnected();

    final message = ShardMessageBuilder()
      .setAction(ShardAction.terminateOk)
      .build();

    _shardPort.send(message);
  }

  Future<void> _connect() async {
    _socket = await WebSocket.connect('$_gatewayUrl?v=10&encoding=json');

    _socketListener = _socket.listen((event) {
      final message = ShardMessageBuilder()
        .setAction(ShardAction.data)
        .setData(WebsocketResponse.fromWebsocket(jsonDecode(event)))
        .build();

      _shardPort.send(message);
    });

    _socket.handleError((err) {
      final message = ShardMessageBuilder()
        .setAction(ShardAction.error)
        .append('error', err.toString())
        .append('code', _socket.closeCode)
        .append('reason', _socket.closeReason)
        .build();

      _shardPort.send(message);
    });

    await for (final ShardMessage message in _stream) {
      switch (message.action) {
        case ShardAction.send:
          if (_socket.closeCode == null) {
            _socket.add(jsonEncode(message.data));
          }
        case ShardAction.reconnect:
          await _disconnected();
          await _connect();
        case ShardAction.terminate:
          await _terminate();
        default:
      }
    }
  }
}