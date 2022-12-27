import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:collection/collection.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/extras.dart';
import 'package:mineral/exception.dart';
import 'package:mineral/src/exceptions/shard_exception.dart';
import 'package:mineral/src/internal/services/debugger.dart';
import 'package:mineral/src/internal/websockets/heartbeat.dart';
import 'package:mineral/src/internal/websockets/sharding/shard_handler.dart';
import 'package:mineral/src/internal/websockets/sharding/shard_manager.dart';
import 'package:mineral/src/internal/websockets/sharding/shard_message.dart';
import 'package:mineral/src/internal/websockets/websocket_dispatcher.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';
import 'package:mineral_cli/mineral_cli.dart';

/// Represents a Discord Shard.
/// A Shard is the object used to interact with the discord websocket.
/// The bot can have one or multiples shards.
///
/// {@category Internal}
class Shard with Container {
  final ShardManager manager;

  final int id;
  final String _token;
  final String gatewayURL;

  late Isolate _isolate;

  late Stream<dynamic> _stream;
  late StreamSubscription<dynamic> _streamSubscription;

  late ReceivePort _receivePort;
  late SendPort _isolateSendPort;
  late SendPort _sendPort;

  late final WebsocketDispatcher dispatcher;

  late int? sequence;
  late Heartbeat _heartbeat;

  late String sessionId;
  late String resumeURL;

  bool _canResume = false;
  bool _pendingReconnect = false;

  bool initialized = false;
  final List<List<dynamic>> queue = [];

  late DateTime lastHeartbeat;
  int latency = -1;

  /// Create a shard instance and launch isolate that will communicate with Discord websockets.
  Shard(this.manager, this.id, this.gatewayURL, this._token) {
    dispatcher = WebsocketDispatcher();
    _heartbeat = Heartbeat(shard: this);

    _spawn();
  }

  /// Spawn an isolate to communicate with the websockets. It's possible to stop and start a
  /// new isolate to restart the connection. The isolate start a function which read [ShardMessage]
  /// and execute actions. When Discord send a socket, the isolate send data [ShardMessage].
  Future<void> _spawn() async {
    _receivePort = ReceivePort();
    _stream = _receivePort.asBroadcastStream();
    _isolateSendPort = _receivePort.sendPort;

    Isolate.spawn(shardHandler, _isolateSendPort).then((isolate) async {
      _isolate = isolate;
      _sendPort = await _stream.first as SendPort;

      _sendPort.send(ShardMessage(command: ShardCommand.init, data: {
        'url': _canResume ? resumeURL : gatewayURL
      }));
      _streamSubscription = _stream.listen(_handle);
    });
  }

  /// Handle the websockets messages
  Future<void> _handle(dynamic message) async {
    final debugger = container.use<Debugger>();
    message = message as ShardMessage;

    switch(message.command) {
      case ShardCommand.data:
        if(message.data is! WebsocketResponse) return;
        final WebsocketResponse data = message.data as WebsocketResponse;

        final OpCode? opCode = OpCode.values.firstWhereOrNull((element) => element.value == data.op);

        debugger.debug('Shard #$id : ${opCode.toString()} | ${data.type ?? ''} ${jsonEncode(data.payload)}');

        switch(opCode) {
          case OpCode.heartbeat: return _heartbeat.reset();
          case OpCode.hello:
            debugger.debug('Shard #$id : Connection initialized with websocket');

            _pendingReconnect = false;
            if(_canResume) {
              _resume();
            } else {
              manager.totalShards >= 2 ? manager.identifyQueue.add(id) : identify();
            }
            _heartbeat.start(Duration(milliseconds: data.payload['heartbeat_interval']));

            break;
          case OpCode.dispatch:
            sequence = data.sequence;
            return await dispatcher.dispatch(data);
          case OpCode.reconnect: return reconnect(resume: true);
          case OpCode.invalidSession: return reconnect(resume: data.payload);
          case OpCode.heartbeatAck:
            latency = DateTime.now().millisecond - lastHeartbeat.millisecond;
            _heartbeat.ackMissing -= 1;

            debugger.debug('Shard #$id : Heartbeat ACK : ${latency}ms');
            break;
          default:
        }
        break;
      case ShardCommand.error:
        final String error = 'Shard #$id ${message.data['reason']} | ${message.data['code']}';
        debugger.debug(error);
        container.use<MineralCli>().console.error(error);

        final Map<int, Function> errors = {
          4000: () => reconnect(resume: true),
          4001: () => reconnect(resume: true),
          4002: () => reconnect(resume: true),
          4003: () => reconnect(resume: false),
          4004: () => {
            _terminate(),
            throw TokenException('INVALID TOKEN, please modify it in .env file')
          },
          4005: () => reconnect(resume: true),
          4007: () => reconnect(resume: false),
          4008: () => {
            container.use<MineralCli>().console.warn('Shard #$id : You send to many packets!'),
            reconnect(resume: false)
          },
          4009: () => reconnect(resume: true),
          4010: () => throw ShardException('Shard #$id : invalid shard id sent to gateway'),
          4011: () => throw ShardException('Shard #$id : sharding is necessary')
        };

        final Function? errorCallback = errors[message.data['code']];
        if (errorCallback != null) {
          return errorCallback();
        }

        container.use<MineralCli>().console.error('Shard #$id : No error callback');
        break;
      case ShardCommand.disconnected:
        if (_pendingReconnect) {
          return debugger.debug('Shard #$id : Websocket disconnected for reconnection');
        }

        container.use<MineralCli>().console.warn('Shard #$id : Websocket disconnected without error, try to reconnect...');
        return reconnect(resume: true);
      case ShardCommand.terminateOk:
        debugger.debug('Shard #$id : Websocket connection terminated, restart...');
        _streamSubscription.cancel();
        _isolate.kill();
        _spawn();
        break;
      default:
        final String error = 'Shard #$id : Websocket disconnected for reconnection';
        container.use<MineralCli>().console.error('Shard #$id : Unhandled message : ${message.command.name}');
        return debugger.debug(error);
    }
  }

  /// Send message to websocket
  void send(OpCode opCode, dynamic data, {bool canQueue = true}) {
    final debugger = container.use<Debugger>();

    if (initialized || canQueue == false) {
      debugger.debug('[SEND] Shard #$id : ${opCode.toString()} | $data');
      final Map<String, dynamic> rawData = {
        'op': opCode.value,
        'd': data
      };
      _sendPort.send(ShardMessage(command: ShardCommand.send, data: rawData));
      return;
    }

    queue.add([opCode, data]);
  }

  /// This method is used by Ready packet to define the Shard ready and send to the websockets the messages queue.
  /// The queue is needed because if we send a message before the Shard identify, the websockets disconnect.
  void initialize() {
    initialized = true;
    for(int i = 0; i < queue.length; i++) {
      final List<dynamic> element = queue[i];

      send(element[0], element[1]);
      queue.removeAt(i);
    }
  }

  /// Identify to the websocket.
  void identify() {
    Map<String, dynamic> identifyData = {
      'token': _token,
      'intents': Intent.getIntent(manager.intents),
      'properties': { '\$os': Platform.operatingSystem }
    };
    if(manager.totalShards >= 2) identifyData.putIfAbsent('shard', () => <int>[id, manager.totalShards]);

    send(OpCode.identify, identifyData, canQueue: false);
  }

  /// In case of errors, it's possible to reconnect to the websockets. This function close the isolate. If resume function is set, the resume message will be send instead of identify to get old events.
  void reconnect({ bool resume = false }) {
    if(!_pendingReconnect) {
      _pendingReconnect = true;
      _canResume = resume;
      _terminate();
      //_sendPort.send(ShardMessage(command: ShardCommand.reconnect));
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
    }, canQueue: false);
  }
}
