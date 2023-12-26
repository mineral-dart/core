import 'dart:async';

import 'package:mineral/application/events/types/listenable.dart';
import 'package:rxdart/rxdart.dart';

final class PacketDispatcher implements Listenable {
  final BehaviorSubject<dynamic> _packets = BehaviorSubject();

  @override
  StreamSubscription listen(Function(dynamic) handle) => _packets.stream.listen(handle);

  @override
  void dispatch(dynamic payload) => _packets.add(payload);

  @override
  void dispose() => _packets.close();
}
