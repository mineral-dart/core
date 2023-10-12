import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:isolate';

import 'package:collection/collection.dart';
import 'package:mineral/internal/services/embedded/embedded_application.dart';
import 'package:mineral/internal/wss/builders/shard_message_builder.dart';
import 'package:mineral/internal/wss/entities/shard_handler.dart';
import 'package:mineral/internal/wss/entities/websocket_message.dart';
import 'package:mineral/internal/wss/entities/websocket_response.dart';
import 'package:mineral/internal/wss/heartbeat.dart';
import 'package:mineral/internal/wss/op_code.dart';
import 'package:mineral/internal/wss/shard_action.dart';
import 'package:mineral/internal/wss/shard_message.dart';
import 'package:mineral/internal/wss/websocket_manager.dart';

final class Shard {
  final EmbeddedApplication application;
  late final Heartbeat _heartbeat;
  final WebsocketManager manager;
  final int id;
  final String gatewayUrl;

  ReceivePort _receivePort = ReceivePort();
  late final SendPort _sendPort;
  Isolate? _isolate;

  late Stream<dynamic> _stream;
  late StreamSubscription<dynamic> _streamSubscription;

  int? sequence;
  String? sessionId;
  String? resumeUrl;

  bool _isResumable = false;
  bool _isPendingReconnect = false;
  bool _isinitialized = false;

  final Queue<WebsocketMessage> queue = Queue();

  DateTime? lastHeartbeat;

  Shard(this.manager, this.application, this.id, this.gatewayUrl) {
    _heartbeat = Heartbeat(this);
    _spawn();
  }

  Future<void> _spawn() async {
    _receivePort = ReceivePort();

    _stream = _receivePort.asBroadcastStream();
    final SendPort isolateSendPort = _receivePort.sendPort;

    final isolate = Isolate.spawn((SendPort port) {
      ShardHandler().handle(port);
    }, isolateSendPort,
      debugName: 'Shard $id'
    );

    isolate.then((isolate) async {
      _isolate = isolate;
      _sendPort = await _stream.first as SendPort;

      final message = ShardMessageBuilder()
        .setAction(ShardAction.init)
        .append('url', _isResumable ? resumeUrl : gatewayUrl)
        .build();

       _sendPort.send(message);
      _streamSubscription = _stream.listen(_handle);
    });
  }

  Future<void> _handle (message) async {
    if (message is! ShardMessage) {
      return;
    }

    return switch (message.action) {
      ShardAction.error => _dispatchErrors(message),
      ShardAction.data => _dispatchActionData(message),
      ShardAction.terminateOk => _handleTerminate(),
      _ => throw Exception('Invalid action')
    };
  }

  void _dispatchErrors (ShardMessage message) {
    final { 'code': int code, 'reason': reason } = message.data;
    print(message.data);

    return switch (code) {
      4000 => _handleReconnect(resume: true),
      4001 => _handleReconnect(resume: true),
      4002 => _handleReconnect(resume: true),
      4003 => _handleReconnect(resume: false),
      4004 => {
        _terminate(),
        throw Exception('[Authentication failed] Your token is invalid'),
      },
      4005 => _handleReconnect(resume: true),
      4007 => _handleReconnect(resume: false),
      4008 => _handleReconnect(resume: false),
      4009 => _handleReconnect(resume: true),
      4010 => {
        _terminate(),
        throw Exception('[Invalid shard] Shard #$id is invalid shard id sent to gateway')
      },
      4011 => {
        _terminate(),
        throw Exception('[Sharding required] Shard #$id : the session would have handled too many guilds')
      },
      4012 => {
        _terminate(),
        throw Exception('[Invalid API version] Shard #$id : You sent an invalid version for the gateway')
      },
      4013 => {
        _terminate(),
        throw Exception('[Invalid intent] Shard #$id : You sent an invalid intent for a Gateway Intent')
      },
      4014 => {
        _terminate(),
        throw Exception('[Disallowed intent] Shard #$id : You sent a disallowed intent for a Gateway Intent')
      },
      _ => throw Exception('Unexpected error code : $code')
    };
  }

  void _dispatchActionData (ShardMessage message) {
    if (message.data is! WebsocketResponse) {
      return;
    }

    final WebsocketResponse response = message.data;
    final OpCode? code = OpCode.values.firstWhereOrNull((element) => element.value == response.opCode);

    return switch (code) {
      OpCode.heartbeat => _heartbeat.reset(),
      OpCode.hello => _handleHello(response),
      OpCode.dispatch => _handleDispatch(response),
      OpCode.heartbeatAck => _heartbeat.ack(),
      OpCode.reconnect => _handleReconnect(),
      OpCode.invalidSession => _handleReconnect(resume: response.payload),
      _ => throw Exception('Invalid opcode : $code')
    };
  }

  void _handleTerminate () {
    _streamSubscription.cancel();
    _isolate?.kill();
    _spawn();
  }

  void _handleHello (WebsocketResponse response) {
    final { 'heartbeat_interval': interval } = response.payload;

    _isPendingReconnect = false;
    if (_isResumable) {
      _resume();
    } else {
      manager.totalShards >= 2
        ? manager.waitingIdentifyQueue.add(id)
        : _identify();
    }

    _heartbeat.beat(Duration(milliseconds: interval));
  }

  void _handleDispatch (WebsocketResponse response) {
    sequence = response.sequence;
    application.sendMessage(response);
  }

  void _handleReconnect ({ bool resume = false }) {
    if (!_isPendingReconnect) {
      _isPendingReconnect = true;
      _isResumable = resume;
      _terminate();
    }
  }

  void _terminate() {
    final message = ShardMessageBuilder()
      .setAction(ShardAction.terminate)
      .build();

    _sendPort.send(message);
  }

  void send ({ required OpCode code, required dynamic payload, bool canQueue = true }) {
    final WebsocketMessage websocketMessage = WebsocketMessage(code, payload);

    if (_isinitialized || canQueue == false) {
      final message = ShardMessageBuilder()
        .setAction(ShardAction.send)
        .setData(websocketMessage.build())
        .build();

      _sendPort.send(message);
      return;
    }

    queue.add(websocketMessage);
  }

  void _identify () {
    final Map<String, dynamic> payload = {
      'token': manager.token,
      'intents': manager.intents.calculatedValue,
      'properties': { '\$os': Platform.operatingSystem },
    };

    if (manager.totalShards >= 2) {
      payload['shard'] = [id, manager.totalShards];
    }

    send(code: OpCode.identify, canQueue: false, payload: payload);
  }

  void _resume () {
    send(
      canQueue: false,
      code: OpCode.resume,
      payload: {
        'token': manager.token,
        'session_id': sessionId,
        'seq': sequence,
      }
    );
  }
}