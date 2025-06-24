import 'dart:io';

import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/services/wss/constants/shard_disconnect_error.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard.dart';

final class ShardNetworkError implements ShardNetworkErrorContract {
  final Shard shard;

  ShardNetworkError(this.shard);

  @override
  void dispatch(dynamic payload) {
    if (payload == null) {
      return;
    }

    if ([1005].contains(payload)) {
      ioc.resolve<LoggerContract>().trace('Unknown error with empty exit code');
      exit(1);
    }

    final ShardDisconnectError? error = ShardDisconnectError.values
        .where((element) => element.code == payload)
        .firstOrNull;

    if (error
        case ShardDisconnectError(canBeReconnected: final canBeReconnected)) {
      return canBeReconnected
          ? shard.authentication.resume()
          : shard.authentication.reconnect();
    }
  }
}
