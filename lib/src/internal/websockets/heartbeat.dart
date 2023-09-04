import 'dart:async';

import 'package:mineral/core.dart';
import 'package:mineral/core/extras.dart';
import 'package:mineral/src/exceptions/shard_exception.dart';
import 'package:mineral/src/internal/websockets/sharding/shard.dart';

class Heartbeat with Console {
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
    ackMissing += 1;

    if (ackMissing == 2) {
      console.warn('Shard #${shard.id} Discord didn\'t receive last heartbeat');
    }

    if (ackMissing >= 3 && ackMissing <= 5) {
      console.error('Shard #${shard.id} Discord didn\'t receive last ${ackMissing - 1} heartbeats, connection restart...');
      shard.reconnect(resume: true);
      return;
    }
    if (ackMissing > 5) {
      console.error('Shard #${shard.id} Discord didn\'t receive last ${ackMissing - 1} heartbeats, shutdown.');
      throw ShardException('Discord didn\'t receive ${ackMissing - 1} heartbeats');
    }

    shard.send(OpCode.heartbeat, shard.sequence, canQueue: false);
    shard.lastHeartbeat = DateTime.now();
  }
}