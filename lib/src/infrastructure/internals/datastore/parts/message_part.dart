import 'dart:async';
import 'dart:io';

import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/domains/commons/utils/extensions.dart';
import 'package:mineral/src/domains/commons/utils/helper.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';

final class MessagePart implements MessagePartContract {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  @override
  Future<T?> get<T extends BaseMessage>(Object channelId, Object id, bool force) async {
    final completer = Completer<T>();

    final cacheKey = _marshaller.cacheKey.message(channelId, id);
    final cachedMessage = await _marshaller.cache?.get(cacheKey);
    if (!force && cachedMessage != null) {
      final message = await _marshaller.serializers.message.serialize(cachedMessage);
      completer.complete(message as T);

      return completer.future;
    }

    final response = await _dataStore.client.get('/channels/$channelId/messages/$id');
    final message = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        await _marshaller.serializers.message.normalize(response.body),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}')
    };

    completer.complete(await _marshaller.serializers.message.serialize(message) as T);
    return completer.future;
  }

  @override
  Future<T> update<T extends Message>({
    required Object id,
    required Object channelId,
    String? content,
    List<MessageEmbed>? embeds,
    List<MessageComponent>? components,
  }) async {
    final completer = Completer<T>();
    final response = await _dataStore.client.patch('/channels/$channelId/messages/$id', body: {
      'content': content,
      'embeds': AsyncList.nullable(embeds?.map(_marshaller.serializers.embed.deserialize).toList()),
      'components': components?.map((c) => c.toJson()).toList()
    });

    final rawMessage = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        await _marshaller.serializers.message.normalize(response.body),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}')
    };

    final message = await _marshaller.serializers.message.serialize(rawMessage);
    completer.complete(message as T);

    return completer.future;
  }

  @override
  Future<void> pin(Snowflake channelId, Snowflake id) async {
    await _dataStore.client.put('/channels/$channelId/pins/$id');
  }

  @override
  Future<void> unpin(Snowflake channelId, Snowflake id) async {
    await _dataStore.client.delete('/channels/$channelId/pins/$id');
  }

  @override
  Future<void> crosspost(Snowflake channelId, Snowflake id) async {
    await _dataStore.client.post('/channels/$channelId/messages/$id/crosspost');
  }

  @override
  Future<void> delete(Snowflake channelId, Snowflake id) async {
    await _dataStore.client.delete('/channels/$channelId/messages/$id');
  }

  @override
  Future<T> send<T extends Message>(Object? guildId, Object channelId, String? content,
      List<MessageEmbed>? embeds, Poll? poll, List<MessageComponent>? components) async {
    final completer = Completer<T>();
    final response = await _dataStore.client.post('/channels/$channelId/messages', body: {
      'content': content,
      'embeds': await Helper.createOrNullAsync(
          field: embeds,
          fn: () async => embeds?.map(_marshaller.serializers.embed.deserialize).toList()),
      'poll': await Helper.createOrNullAsync(
          field: poll, fn: () async => _marshaller.serializers.poll.deserialize(poll!)),
      'components': components?.map((e) => e.toJson()).toList(),
    });

    final message = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        await _marshaller.serializers.message.normalize(response.body),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}')
    };

    completer.complete(await _marshaller.serializers.message.serialize(message) as T);

    return completer.future;
  }

  @override
  Future<R> reply<T extends Channel, R extends Message>(
      {required Snowflake id,
      required Snowflake channelId,
      String? content,
      List<MessageEmbed>? embeds,
      List<MessageComponent>? components}) async {
    final completer = Completer<R>();

    final result = await _dataStore.requestBucket.run<Map<String, dynamic>>(
        () => _dataStore.client.post('/channels/$channelId/messages', body: {
              'content': content,
              'embeds': AsyncList.nullable(embeds?.map(_marshaller.serializers.embed.deserialize)),
              'components': components?.map((c) => c.toJson()).toList(),
              'message_reference': {'message_id': id, 'channel_id': channelId}
            }));
    final raw = await _marshaller.serializers.message.normalize(result);
    final message = await _marshaller.serializers.message.serialize(raw) as R;

    completer.complete(message);
    return completer.future;
  }
}
