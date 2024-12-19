import 'dart:async';

import 'package:mineral/src/infrastructure/services/wss/websocket_message.dart';

abstract interface class RunningStrategy {
  FutureOr<void> init();
  FutureOr<void> dispatch(WebsocketMessage message);
}
