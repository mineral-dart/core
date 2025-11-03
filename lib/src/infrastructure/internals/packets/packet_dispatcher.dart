import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/common/kernel.dart';
import 'package:mineral/src/domains/services/packets/packet_dispatcher.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:rxdart/rxdart.dart';

final class PacketDispatcher implements PacketDispatcherContract {
  final BehaviorSubject<ShardMessage> _packets = BehaviorSubject();
  final Kernel _kernel;

  PacketDispatcher(this._kernel);

  @override
  void listen(PacketTypeContract packet,
      Function(ShardMessage, DispatchEvent) listener) {
    _packets.stream
        .where((event) => event.type == packet.name)
        .listen((ShardMessage message) {
      Function.apply(
          listener, [message, _kernel.eventListener.dispatcher.dispatch]);
    });
  }

  @override
  void dispatch(dynamic payload) => _packets.add(payload);

  @override
  void dispose() => _packets.close();
}
