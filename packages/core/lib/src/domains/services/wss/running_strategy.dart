import 'dart:async';

import 'package:mineral/src/infrastructure/services/wss/websocket_message.dart';

typedef RunningStrategyFactory = FutureOr<void> Function(RunningStrategy);

abstract interface class RunningStrategy {
  FutureOr<void> init(RunningStrategyFactory createShards);
  FutureOr<void> dispatch(WebsocketMessage message);
}
