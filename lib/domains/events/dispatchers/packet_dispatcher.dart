import 'package:mineral/domains/events/event_manager.dart';
import 'package:mineral/domains/events/types/packet_type.dart';
import 'package:mineral/domains/events/types/listenable_dispatcher.dart';
import 'package:mineral/domains/events/types/listenable_packet.dart';
import 'package:mineral/domains/wss/shard_message.dart';
import 'package:rxdart/rxdart.dart';

final class PacketDispatcher implements ListenableDispatcher {
  final EventManager _manager;
  final BehaviorSubject<ShardMessage> _packets = BehaviorSubject();

  PacketDispatcher(this._manager);

  @override
  void listen(dynamic payload) {
    final PacketType packet = payload['packet'];
    final Function(Map<String, dynamic>) listener = payload['listener'];

    _packets.stream.where((event) => event.type == packet.name).listen(
        (ShardMessage message) =>
            listener({'message': message, 'dispatch': _manager.events.dispatch}));
  }

  @override
  void dispatch(dynamic payload) => _packets.add(payload);

  @override
  void dispose() => _packets.close();
}
