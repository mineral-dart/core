import 'dart:async';
import 'dart:isolate';

import 'package:mineral/internal/wss/websocket_manager.dart';

final class Shard {
  final WebsocketManager manager;
  final int id;
  final String gatewayUrl;

  late Isolate _isolate;
  final ReceivePort _receivePort = ReceivePort();
  late final SendPort _sendPort;

  late Stream<dynamic> _stream;
  late StreamSubscription<dynamic> _streamSubscription;


  int? sequence;
  String? sessionId;
  String? resumeUrl;

  bool _isResumable = false;
  bool _isPendingReconnect = false;
  bool _isinitialized = false;

  DateTime? lastHeartbeat;

  Shard({ required this.manager, required this.id, required this.gatewayUrl });

  Future<void> spawn() async {
    _stream = _receivePort.asBroadcastStream();

    // _isolate = await Isolate.spawn(message, () => {});
    // _sendPort = await _stream.first;
    //
    // _sendPort.send(ShardMessage(
    //   action: ShardAction.init,
    //   data: { 'url': _isResumable ? resumeUrl : gatewayUrl }
    // ));
    //
    // _streamSubscription = _stream.listen(print);
  }
}