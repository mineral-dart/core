import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';

final class ReactionPart implements ReactionPartContract {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  @override
  Future<Map<Snowflake, User>> getUsersForEmoji(
    Object channelId,
    Object messageId,
    PartialEmoji emoji,
  ) async {
    final value = emoji.id != null ? '${emoji.name}:${emoji.id}' : emoji.name;

    final complete = Completer<Map<Snowflake, User>>();
    final req = Request.json(
      endpoint: '/channels/$channelId/messages/$messageId/reactions/$value',
    );
    final result = await _dataStore.requestBucket
        .query<List<Map<String, dynamic>>>(req)
        .run(_dataStore.client.get);

    final users = await result.map((element) async {
      final raw = await _marshaller.serializers.user.normalize(element);
      return _marshaller.serializers.user.serialize(raw);
    }).wait;

    complete.complete(
      users.asMap().map((key, value) => MapEntry(value.id, value)),
    );
    return complete.future;
  }

  @override
  Future<void> add(
    Object channelId,
    Object messageId,
    PartialEmoji emoji,
  ) async {
    final value = emoji.id != null ? '${emoji.name}:${emoji.id}' : emoji.name;
    final req = Request.json(
      endpoint: '/channels/$channelId/messages/$messageId/reactions/$value/@me',
    );
    await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.put);
  }

  @override
  Future<void> remove(
    Object channelId,
    Object messageId,
    PartialEmoji emoji,
  ) async {
    final value = emoji.id != null ? '${emoji.name}:${emoji.id}' : emoji.name;
    final req = Request.json(
      endpoint: '/channels/$channelId/messages/$messageId/reactions/$value/@me',
    );
    await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.delete);
  }

  @override
  Future<void> removeAll(Object channelId, Object messageId) {
    final req = Request.json(
      endpoint: '/channels/$channelId/messages/$messageId/reactions',
    );
    return _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.delete);
  }

  @override
  Future<void> removeForEmoji(
    Object channelId,
    Object messageId,
    PartialEmoji emoji,
  ) {
    final value = emoji.id != null ? '${emoji.name}:${emoji.id}' : emoji.name;
    final req = Request.json(
      endpoint: '/channels/$channelId/messages/$messageId/reactions/$value',
    );
    return _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.delete);
  }

  @override
  Future<void> removeForUser(
    Object userId,
    Object channelId,
    Object messageId,
    PartialEmoji emoji,
  ) async {
    final value = emoji.id != null ? '${emoji.name}:${emoji.id}' : emoji.name;
    final req = Request.json(
      endpoint:
          '/channels/$channelId/messages/$messageId/reactions/$value/$userId',
    );
    await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.delete);
  }
}
