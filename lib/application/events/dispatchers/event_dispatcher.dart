import 'dart:async';

import 'package:mineral/application/events/types/listenable.dart';
import 'package:rxdart/rxdart.dart';

final class EventDispatcher implements Listenable {
  final BehaviorSubject<dynamic> _events = BehaviorSubject();

  @override
  StreamSubscription listen(Function(dynamic) handle) => _events.stream.listen(handle);

  @override
  void dispatch(dynamic payload) => _events.add(payload);

  @override
  void dispose() => _events.close();
}
