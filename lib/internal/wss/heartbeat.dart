import 'dart:async';

import 'package:mineral/internal/wss/op_code.dart';
import 'package:mineral/internal/wss/shard.dart';

final class Heartbeat {
  final Shard _shard;
  Duration? _delay;
  Timer? _timer;
  int ackMissing = 0;

  Heartbeat(this._shard);

  void beat (Duration delay) {
    _delay = delay;
    _timer = Timer.periodic(delay, (_) => _send());
  }

  void ack () {
    ackMissing -= 1;
  }

  void _cancel () {
    _timer?.cancel();
    ackMissing = 0;
  }

  void reset () {
    _cancel();

    if (_delay != null) {
      _timer = Timer.periodic(_delay!, (_) => _send());
    }
  }

  void _send() {
    ackMissing += 1;

    _shard.send(code: OpCode.heartbeat, payload: _shard.sequence, canQueue: false);
    _shard.lastHeartbeat = DateTime.now();
  }
}