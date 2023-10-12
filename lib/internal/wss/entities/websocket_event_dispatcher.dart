import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:mineral/api/common/collection.dart';
import 'package:mineral/internal/wss/contracts/packet_contract.dart';
import 'package:mineral/internal/wss/entities/packet_type.dart';
import 'package:mineral/internal/wss/entities/websocket_response.dart';
import 'package:mineral/internal/wss/packets/ready_packet.dart';

final class WebsocketEventDispatcher {
  final Collection<PacketType, PacketContract> packets = Collection();
  final Queue<WebsocketResponse> _eventQueue = Queue();

  bool _isRestoring = false;

  WebsocketEventDispatcher() {
    packets.putIfAbsent(PacketType.ready, () => ReadyPacket());
  }

  Future<void> dispatch (WebsocketResponse response, { bool pushToQueue = false }) async {
    if (pushToQueue) {
      _eventQueue.addLast(response);
    }

    final type = PacketType.values.firstWhereOrNull((element) => element.value == response.type);
    if (type == null) {
      return;
    }

    final packet = packets.get(type);
    packet?.handle(response);
  }

  void restoreEvents () {
    final queue = Queue<WebsocketResponse>.from(_eventQueue);

    _isRestoring = true;
    while (queue.isNotEmpty) {
      dispatch(queue.removeFirst());
    }
    _isRestoring = false;
  }
}