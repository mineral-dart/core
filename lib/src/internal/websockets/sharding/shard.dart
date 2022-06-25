import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:async';

import 'package:mineral/console.dart';
import 'package:mineral/core.dart';
import 'package:mineral/exception.dart';
import 'package:mineral/src/internal/websockets/heartbeat.dart';
import 'package:mineral/src/internal/websockets/sharding/shard_handler.dart';
import 'package:mineral/src/internal/websockets/sharding/shard_manager.dart';
import 'package:mineral/src/internal/websockets/sharding/shard_message.dart';
import 'package:mineral/src/internal/websockets/websocket_dispatcher.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

import 'package:mineral/src/exceptions/shard_exception.dart';

class Shard {
  final ShardManager manager;

  final int id;
  final String _token;
  //final String gatewayURL;

  late final Isolate _isolate;
  late final Stream<dynamic> _stream;
  late final ReceivePort _receivePort;
  late final SendPort _isolateSendPort;
  late SendPort _sendPort;

  late final WebsocketDispatcher dispatcher;

  late int? sequence;
  late Heartbeat _heartbeat;

  late String sessionId;

  bool _canResume = false;
  bool _pendingReconnect = false;

  Shard(this.manager, this.id, String gatewayURL, this._token) {
    Console.info(prefix: "Shard #$id", message: manager.totalShards.toString());
    dispatcher = WebsocketDispatcher();
    _heartbeat = Heartbeat(shard: this);

    _receivePort = ReceivePort();
    _stream = _receivePort.asBroadcastStream();
    _isolateSendPort = _receivePort.sendPort;

    Isolate.spawn(shardHandler, _isolateSendPort).then((isolate) async {
      _isolate = isolate;
      _sendPort = await _stream.first as SendPort;

      _sendPort.send(ShardMessage(command: ShardCommand.init, data: {
        'url': gatewayURL
      }));
      _stream.listen(_handle);
    });
  }

  Future<void> _handle(dynamic message) async {
    message = message as ShardMessage;

    switch(message.command) {
      case ShardCommand.data:
        if(message.data is! WebsocketResponse) return;
        final WebsocketResponse data = message.data as WebsocketResponse;
        sequence = data.sequence;

        Console.debug(message: data.op.toString() + " | " + data.payload.toString(), prefix: "Shard #$id");

        switch(OpCode.getWithValue(data.op)) {
          case OpCode.heartbeat: return _heartbeat.reset();
          case OpCode.hello:
            Console.success(message: "Received Hello code, shard started!", prefix: "Shard #$id");
            _pendingReconnect = false;
            _canResume ? _resume : _identify();
            _heartbeat.start(Duration(milliseconds: data.payload["heartbeat_interval"]));
            break;
          case OpCode.dispatch: return await dispatcher.dispatch(data);
          case OpCode.reconnect:
            return _reconnect(resume: true);
          case OpCode.invalidSession:
            _reconnect(resume: data.payload);
        }
        break;
      case ShardCommand.error:
        Console.error(prefix: "Shard #$id", message: message.data["reason"] + " | " + message.data["code"]);

        final Map<int, Function> errors = {
          4000: () => _reconnect(resume: true),
          4001: () => _reconnect(resume: true),
          4002: () => _reconnect(resume: true),
          4003: () => _reconnect(resume: false),
          4004: () => {
            _terminate(),
            throw TokenException(cause: "Change the APP_TOKEN", prefix: "WRONG TOKEN")
          },
          4005: () => _reconnect(resume: true),
          4007: () => _reconnect(resume: false),
          4008: () => {
            Console.warn(prefix: "Shard #$id", message: 'You\'re ratelimited!'),
            _reconnect(resume: false)
          },
          4009: () => _reconnect(resume: true),
          4010: () => throw ShardException(prefix: "Shard #$id", cause: "Invalid shard id sended to gateway"),
          4011: () => throw ShardException(prefix: "Shard #$id", cause: "Sharding is necessary")
        };

        final Function? errorCallback = errors[message.data['code']];
        if(errorCallback != null) {
          errorCallback();
        } else {
          Console.error(prefix: "Shard #$id", message: "Websocket disconnected");
        }
        break;
      case ShardCommand.disconnected:
        Console.warn(prefix: "Shard #$id", message: "Websocket disconnected");
        return _reconnect(resume: true);
      default:
        Console.info(prefix: "Shard #$id", message: "Unhandled error");
    }
  }

  void send(OpCode opCode, dynamic data) {
    final dynamic rawData = {
      "op": opCode.value,
      "d": data
    };
    _sendPort.send(ShardMessage(command: ShardCommand.send, data: rawData));
  }

  void _identify() {
    send(OpCode.identify, {
      'token': _token,
      'intents': 131071,
      'shard': <int>[id, manager.totalShards],
      'properties': { '\$os': Platform.operatingSystem }
    });
  }

  void _reconnect({ bool resume = false }) {
    if(!_pendingReconnect) {
      _pendingReconnect = true;
      _canResume = resume;
      _sendPort.send(ShardMessage(command: ShardCommand.reconnect));
    }
  }
  
  void _terminate() {
    _sendPort.send(ShardMessage(command: ShardCommand.terminate));
  }

  void _resume() {
    send(OpCode.resume, {
      'token': _token,
      'session_id': sessionId,
      'seq': sequence
    });
  }
}