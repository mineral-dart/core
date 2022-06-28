import 'dart:async';

import 'package:mineral/console.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/websockets/sharding/shard.dart';

class Heartbeat {
  final Shard shard;

  Duration? _delay;
  Timer? _timer;

  int ackMissing = 0;

  Heartbeat({ required this.shard });

  void start (Duration delay) {
    _delay = delay;

    cancel();
    _timer = Timer.periodic(delay, (Timer timer) => _send());
  }

  void cancel () {
    _timer?.cancel();
    ackMissing = 0;
  }

  void reset() {
    cancel();

    if (_delay != null) {
      _timer = Timer.periodic(_delay!, (Timer timer) => _send());
    }
  }

  void _send() {
    Console.debug(message: 'Send an heartbeat', prefix: 'Shard #${shard.id}');

    if(ackMissing == 1) Console.warn(message: 'Discord didn\'t receive last heartbeat', prefix: 'Shard #${shard.id}');
    if(ackMissing >= 2) {
      Console.error(message: 'Discord didn\'t receive last $ackMissing heartbeats, connection restart...', prefix: 'Shard #${shard.id}');
      shard.reconnect(resume: true);
      return;
    }

    shard.send(OpCode.heartbeat, shard.sequence, canQueue: false);
    ackMissing += 1;
  }
}