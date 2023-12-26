import 'dart:async';

import 'package:mineral/domains/events/types/listenable.dart';
import 'package:mineral/domains/wss/shard_message.dart';
import 'package:rxdart/rxdart.dart';

final class PacketDispatcher implements Listenable<ShardMessage> {
  final BehaviorSubject<ShardMessage> _packets = BehaviorSubject();

  @override
  StreamSubscription listen(Function(ShardMessage) handle) => _packets.stream.listen(handle);

  @override
  void dispatch(dynamic payload) => _packets.add(payload);

  @override
  void dispose() => _packets.close();
}
