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
      Object channelId, Object messageId, PartialEmoji emoji) async {
    final value = emoji.id != null ? '${emoji.name}:${emoji.id}' : emoji.name;

    final complete = Completer<Map<Snowflake, User>>();
    final result = await _dataStore.requestBucket.run<List>(
        () => _dataStore.client.get('/channels/$channelId/messages/$messageId/reactions/$value'));

    final users = await result.map((element) async {
      final raw = await _marshaller.serializers.user.normalize(element);
      return _marshaller.serializers.user.serialize(raw);
    }).wait;

    complete.complete(users.asMap().map((key, value) => MapEntry(value.id, value)));
    return complete.future;
  }

  @override
  Future<void> add(Object channelId, Object messageId, PartialEmoji emoji) async {
    final value = emoji.id != null ? '${emoji.name}:${emoji.id}' : emoji.name;
    await _dataStore.requestBucket.run(() =>
        _dataStore.client.put('/channels/$channelId/messages/$messageId/reactions/$value/@me'));
  }

  @override
  Future<void> remove(Object channelId, Object messageId, PartialEmoji emoji) async {
    final value = emoji.id != null ? '${emoji.name}:${emoji.id}' : emoji.name;
    await _dataStore.requestBucket.run(() =>
        _dataStore.client.delete('/channels/$channelId/messages/$messageId/reactions/$value/@me'));
  }

  @override
  Future<void> removeAll(Object channelId, Object messageId) {
    return _dataStore.requestBucket.run(
        () => _dataStore.client.delete('/channels/$channelId/messages/$messageId/reactions'));
  }

  @override
  Future<void> removeForEmoji(Object channelId, Object messageId, PartialEmoji emoji) {
    final value = emoji.id != null ? '${emoji.name}:${emoji.id}' : emoji.name;
    return _dataStore.requestBucket.run(() =>
        _dataStore.client.delete('/channels/$channelId/messages/$messageId/reactions/$value'));
  }

  @override
  Future<void> removeForUser(
      Object userId, Object channelId, Object messageId, PartialEmoji emoji) async {
    final value = emoji.id != null ? '${emoji.name}:${emoji.id}' : emoji.name;
    await _dataStore.requestBucket.run(() => _dataStore.client
        .delete('/channels/$channelId/messages/$messageId/reactions/$value/$userId'));
  }
}
