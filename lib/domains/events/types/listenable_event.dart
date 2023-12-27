import 'dart:async';

import 'package:mineral/domains/events/types/packet_type.dart';

abstract interface class ListenableEvent {
  String get event;
  FutureOr<void> handle(dynamic data);
}
