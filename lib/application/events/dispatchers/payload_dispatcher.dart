import 'dart:async';

import 'package:mineral/application/events/types/listenable.dart';
import 'package:rxdart/rxdart.dart';

final class PayloadDispatcher implements Listenable {
  final BehaviorSubject<dynamic> _payloads = BehaviorSubject();

  @override
  StreamSubscription listen(Function(dynamic) handle) => _payloads.stream.listen(handle);

  @override
  void dispatch(dynamic payload) => _payloads.add(payload);

  @override
  void dispose() => _payloads.close();
}
