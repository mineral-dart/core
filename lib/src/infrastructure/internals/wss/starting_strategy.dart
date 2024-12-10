import 'dart:async';
import 'dart:convert';

import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/commons/kernel.dart';
import 'package:mineral/src/infrastructure/internals/hmr/hot_module_reloading.dart';
import 'package:mineral/src/infrastructure/services/wss/websocket_message.dart';

abstract interface class DispatchStrategy {
  FutureOr<void> dispatch(WebsocketMessage message);
}

final class DispatchHmrStrategy implements DispatchStrategy {
  LoggerContract get _logger => ioc.resolve<LoggerContract>();
  final HotModuleReloading hmr;

  DispatchHmrStrategy(this.hmr) {
    _logger.trace('HMR strategy initialized');
  }

  @override
  FutureOr<void> dispatch(WebsocketMessage message) {
    hmr.devSendPort?.send(json.decode(message.originalContent));
  }
}

final class DispatchDefaultStrategy implements DispatchStrategy {
  final KernelContract kernel;

  DispatchDefaultStrategy(this.kernel) {
    kernel.logger.trace('Default strategy initialized');
  }

  @override
  FutureOr<void> dispatch(WebsocketMessage payload) {
    kernel.packetListener.dispatcher.dispatch(payload.content);
  }
}
