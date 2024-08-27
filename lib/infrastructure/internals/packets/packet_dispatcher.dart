import 'dart:convert';

import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';
import 'package:rxdart/rxdart.dart';

abstract interface class PacketDispatcherContract {
  void listen(
      PacketType packet, Function(ShardMessage, DispatchEvent) listener);

  void dispatch(dynamic payload);

  void dispose();
}

final class PacketDispatcher implements PacketDispatcherContract {
  final BehaviorSubject<ShardMessage> _packets = BehaviorSubject();
  final KernelContract _kernel;

  PacketDispatcher(this._kernel);

  @override
  void listen(
      PacketType packet, Function(ShardMessage, DispatchEvent) listener) {
    _packets.stream
        .where((event) => event.type == packet.name)
        .listen((ShardMessage message) {
      _kernel.logger.trace(jsonEncode(message.serialize()));
      Function.apply(
          listener, [message, _kernel.eventListener.dispatcher.dispatch]);
    });
  }

  @override
  void dispatch(dynamic payload) => _packets.add(payload);

  @override
  void dispose() => _packets.close();
}
