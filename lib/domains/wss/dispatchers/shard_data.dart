import 'dart:convert';

import 'package:mineral/infrastructure/hmr/hot_module_reloading.dart';
import 'package:mineral/infrastructure/services/wss/websocket_message.dart';
import 'package:mineral/domains/wss/shard.dart';
import 'package:mineral/domains/wss/shard_message.dart';

abstract interface class ShardData {
  void dispatch(WebsocketMessage message);
}

final class ShardDataImpl implements ShardData {
  final HotModuleReloading? hmr;
  final Shard _shard;

  ShardDataImpl(Shard shard)
      : _shard = shard,
        hmr = shard.kernel.hmr;

  @override
  void dispatch(WebsocketMessage message) {
    if (message.content case ShardMessage(:final type, :final payload) when type == 'READY') {
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
    _shard.kernel.dataListener.packets.dispatch(message.content);
  }
}
