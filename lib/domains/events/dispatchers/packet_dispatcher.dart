import 'dart:async';

import 'package:mineral/domains/events/types/listenable_dispatcher.dart';
import 'package:mineral/domains/wss/shard_message.dart';
import 'package:rxdart/rxdart.dart';

final class PacketDispatcher implements ListenableDispatcher<ShardMessage> {
  final BehaviorSubject<ShardMessage> _packets = BehaviorSubject();

  @override
  StreamSubscription listen(Function(ShardMessage) handle) => _packets.stream.listen(handle);

  @override
  void dispatch(dynamic payload) => _packets.add(payload);

  @override
  void dispose() => _packets.close();
}
