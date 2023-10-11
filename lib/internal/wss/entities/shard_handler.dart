import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

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
      _shardPort.send(ShardMessage(
        action: ShardAction.error,
        data: {
          'reason': error,
          'code': _socket.closeCode
        }
      ));
    } finally {
      print('error');
    }
  }

  Future<void> _disconnected () async {
    await _socketListener.cancel();
    await _socket.close(4000, 'Shard disconnected');
  }

  Future<void> _terminate() async {
    await _disconnected();
    _shardPort.send(ShardMessage(
      action: ShardAction.terminateOk
    ));
  }

  Future<void> _connect() async {
    print(_gatewayUrl);
    _socket = await WebSocket.connect('$_gatewayUrl?v=10&encoding=json');

    _socketListener = _socket.listen((event) {
      _shardPort.send(ShardMessage(
        action: ShardAction.data,
        data: WebsocketResponse.fromWebsocket(jsonDecode(event))
      ));
    });

    _socket.handleError((err) => {
      _shardPort.send(ShardMessage(
        action: ShardAction.error,
        data: {
          'error': err.toString(),
          'code': _socket.closeCode,
          'reason': _socket.closeReason
        })
      )
    });

    // await _socket.done;
    //
    // _shardPort.send(ShardMessage(
    //   action: ShardAction.disconnected,
    //   data: {
    //     'code': _socket.closeCode,
    //     'reason': _socket.closeReason
    //   }
    // ));

    await for (final ShardMessage message in _stream) {
      print('From stream ${message.action} : ${message.data}');
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