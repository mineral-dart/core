import 'dart:convert';

import 'package:mineral/contracts.dart';
import 'package:mineral/src/infrastructure/internals/hmr/hot_module_reloading.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/infrastructure/services/wss/websocket_message.dart';

final class ShardData implements ShardDataContract {
  final HotModuleReloading? hmr;
  final Shard _shard;

  ShardData(Shard shard)
      : _shard = shard,
        hmr = shard.kernel.hmr;

  @override
  void dispatch(WebsocketMessage message) {
    if (message.content case ShardMessage(:final type, :final payload)
        when type == 'READY') {
      _shard.authentication.setupRequirements(payload);
    }

    if (hmr != null) {
      dispatchWithHmr(message);
    } else {
      dispatchWithoutHmr(message);
    }
  }

  void dispatchWithHmr(WebsocketMessage message) {
    hmr!.devSendPort?.send(jsonDecode(message.originalContent));
  }

  void dispatchWithoutHmr(WebsocketMessage message) {
    _shard.kernel.packetListener.dispatcher.dispatch(message.content);
  }
}
