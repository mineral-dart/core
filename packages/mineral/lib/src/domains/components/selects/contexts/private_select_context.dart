import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';

final class PrivateSelectContext extends ComponentContextBase
    implements SelectContext {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  final Snowflake userId;

  final Snowflake? messageId;

  final Snowflake? channelId;

  PrivateSelectContext({
    required super.id,
    required super.applicationId,
    required super.token,
    required super.version,
    required super.customId,
    required this.messageId,
    required this.userId,
    required this.channelId,
  });

  Future<User?> resolveUser({bool force = false}) =>
      _datastore.user.get(userId.value, force);

  FutureOr<PrivateMessage?> resolveMessage({bool force = false}) {
    if ([channelId, messageId].contains(null)) {
      return null;
    }

    return _datastore.message.get(channelId!.value, messageId!.value, force);
  }

  FutureOr<PrivateChannel?> resolveChannel({bool force = false}) {
    if (channelId == null) {
      return null;
    }

    return _datastore.channel.get<PrivateChannel>(channelId!.value, force);
  }

  static Future<PrivateSelectContext> fromMap(MarshallerContract marshaller,
      DataStoreContract datastore, Map<String, dynamic> payload) async {
    return PrivateSelectContext(
      customId: payload['data']['custom_id'],
      id: Snowflake.parse(payload['id']),
      applicationId: Snowflake.parse(payload['application_id']),
      token: payload['token'],
      version: payload['version'],
      userId: Snowflake.parse(payload['user']['id']),
      messageId: Snowflake.nullable(payload['message']['id']),
      channelId: Snowflake.nullable(payload['channel_id']),
    );
  }
}
