import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/infrastructure/internals/interactions/interaction.dart';

final class PrivateSelectContext implements SelectContext {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  @override
  final Snowflake id;

  @override
  final Snowflake applicationId;

  @override
  final String token;

  @override
  final int version;

  @override
  final String customId;

  final Snowflake userId;

  final Snowflake? messageId;

  final Snowflake? channelId;

  late final InteractionContract interaction;

  PrivateSelectContext({
    required this.id,
    required this.applicationId,
    required this.token,
    required this.version,
    required this.customId,
    required this.messageId,
    required this.userId,
    required this.channelId,
  }) {
    interaction = Interaction(token, id);
  }

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
