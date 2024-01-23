import 'dart:convert';

import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/data_listener.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/wss/shard_message.dart';
import 'package:rxdart/rxdart.dart';

abstract interface class PacketDispatcherContract {
  void listen(PacketType packet,
      Function(ShardMessage, Function({required String event, required List params})) listener);

  void dispatch(dynamic payload);

  void dispose();
}

final class PacketDispatcher implements PacketDispatcherContract {
  final BehaviorSubject<ShardMessage> _packets = BehaviorSubject();

  final DataListenerContract _manager;
  final LoggerContract _logger;

  PacketDispatcher(this._manager, this._logger);

  @override
  void listen(PacketType packet,
      Function(ShardMessage, Function({required String event, required List params})) listener) {
    _packets.stream.where((event) => event.type == packet.name).listen((ShardMessage message) {
      _logger.trace(jsonEncode(message.serialize()));
      Function.apply(listener, [message, _manager.events.dispatch]);
    });
  }

  @override
  void dispatch(dynamic payload) => _packets.add(payload);

  @override
  void dispose() => _packets.close();
}
