import 'dart:async';

import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/common/kernel.dart';
import 'package:mineral/src/domains/services/packets/packet_dispatcher.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/ready_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:rxdart/rxdart.dart';

final class PacketDispatcher implements PacketDispatcherContract {
  final BehaviorSubject<ShardMessage> _packets = BehaviorSubject();
  final List<StreamSubscription> _subscriptions = [];
  final Kernel _kernel;

  PacketDispatcher(this._kernel);

  @override
  void listen(PacketTypeContract packet,
      Function(ShardMessage, DispatchEvent) listener) {
    final subscription = _packets.stream
        .where((event) => event.type == packet.name)
        .listen((ShardMessage message) {
      if (message.type == PacketType.ready.name) {
        ioc.bind(() => ReadyPacketMessage(message));
      }
      Function.apply(
          listener, [message, _kernel.eventListener.dispatcher.dispatch]);
    });

    _subscriptions.add(subscription);
  }

  @override
  void dispatch(dynamic payload) => _packets.add(payload);

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
    _packets.close();
  }
}
