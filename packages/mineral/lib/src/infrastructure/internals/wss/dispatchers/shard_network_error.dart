import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/common/kernel.dart';
import 'package:mineral/src/domains/services/wss/constants/shard_disconnect_error.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard.dart';
import 'package:mineral/src/infrastructure/io/exceptions/fatal_gateway_exception.dart';

final class ShardNetworkError implements ShardNetworkErrorContract {
  final Shard shard;

  ShardNetworkError(this.shard);

  @override
  void dispatch(dynamic payload) {
    if (payload == null) {
      return;
    }

    final logger = ioc.resolve<LoggerContract>();

    final ShardDisconnectError? error = ShardDisconnectError.values
        .where((element) => element.code == payload)
        .firstOrNull;

    if (error != null) {
      logger.warn('WebSocket closed with code ${error.code}: ${error.message}');

      switch (error.action) {
        case DisconnectAction.resume:
          logger.trace('Attempting to resume session');
          shard.authentication.resume();
        case DisconnectAction.reconnect:
          logger.trace('Attempting full reconnect');
          shard.authentication.reconnect();
        case DisconnectAction.fatal:
          logger.error(
              'Fatal gateway error: ${error.message} (${error.code}). Cannot reconnect.');
          shard.authentication.cancelHeartbeat();
          shard.client.disconnect();
          ioc.resolve<Kernel>().dispose();
          throw FatalGatewayException(error.message, error.code);
      }
      return;
    }

    logger.warn(
        'WebSocket closed with unknown code: $payload. Attempting reconnect.');
    shard.authentication.reconnect();
  }
}
