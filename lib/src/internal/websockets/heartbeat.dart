import 'dart:async';

import 'package:mineral/console.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/websockets/sharding/shard.dart';

class Heartbeat {
  final Shard shard;

  Duration? _delay;
  Timer? _timer;

  Heartbeat({ required this.shard });

  void start (Duration delay) {
    _delay = delay;

    cancel();
    _timer = Timer.periodic(delay, (Timer timer) => _send());
  }

  void cancel () {
    _timer?.cancel();
  }

  void reset() {
    cancel();

    if (_delay != null) {
      _timer = Timer.periodic(_delay!, (Timer timer) => _send());
    }
  }

  void _send() {
    Console.info(message: "Send an heartbeat");
    shard.send(OpCode.heartbeat, shard.sequence);
  }
}