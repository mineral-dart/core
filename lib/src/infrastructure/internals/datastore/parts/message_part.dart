import 'dart:async';
import 'dart:io';

import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/api/common/polls/poll_answer_vote.dart';
import 'package:mineral/src/domains/common/utils/attachment.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';

final class MessagePart implements MessagePartContract {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  @override
  Future<Map<Snowflake, T>> fetch<T extends BaseMessage>(Object channelId,
      {Snowflake? around,
      Snowflake? before,
      Snowflake? after,
      int? limit}) async {
    final completer = Completer<Map<Snowflake, T>>();

    final query = {
      if (around != null) 'around': around.value,
      if (before != null) 'before': before.value,
      if (after != null) 'after': after.value,
      if (limit != null) 'limit': limit,
    };

    final req = Request.json(
        endpoint: query.isEmpty
            ? '/channels/$channelId/messages'
            : '/channels/$channelId/messages?${query.entries.map((e) => '${e.key}=${e.value}').join('&')}');
    final response = await _dataStore.client.get(req);

    final messages = await switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) => Future.wait(
          List.from(response.body)
              .map((e) async => _marshaller.serializers.message.normalize(e))),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) =>
        throw HttpException(response.bodyString),
      _ => throw Exception(
          'Unknown status code: ${response.statusCode} ${response.bodyString}')
    };

    final serializedMessages = await Future.wait(messages
        .map((e) => _marshaller.serializers.message.serialize(e) as Future<T>));

    final Map<Snowflake, T> results = serializedMessages.fold({},
        (previousValue, element) => {...previousValue, element.id: element});

    completer.complete(results);
    return completer.future;
  }

  @override
  Future<T?> get<T extends BaseMessage>(
      Object channelId, Object id, bool force) async {
    final completer = Completer<T>();

    final cacheKey = _marshaller.cacheKey.message(channelId, id);
    final cachedMessage = await _marshaller.cache?.get(cacheKey);
    if (!force && cachedMessage != null) {
      final message =
          await _marshaller.serializers.message.serialize(cachedMessage);
      completer.complete(message as T);

      return completer.future;
    }

    final req = Request.json(endpoint: '/channels/$channelId/messages/$id');
    final response = await _dataStore.client.get(req);

    final message = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        await _marshaller.serializers.message.normalize(response.body),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) =>
        throw HttpException(response.bodyString),
      _ => throw Exception(
          'Unknown status code: ${response.statusCode} ${response.bodyString}')
    };

    completer.complete(
        await _marshaller.serializers.message.serialize(message) as T);
    return completer.future;
  }

  @override
  Future<T> update<T extends Message>({
    required Object id,
    required Object channelId,
    required MessageBuilder builder,
  }) async {
    final completer = Completer<T>();
    final (components, files) = makeAttachmentFromBuilder(builder);

    final payload = {
      'flags': MessageFlagType.isComponentV2.value,
      'components': components
    };
    final req = switch (files.isEmpty) {
      true => Request.json(
          endpoint: '/channels/$channelId/messages/$id', body: payload),
      false => Request.formData(
          endpoint: '/channels/$channelId/messages/$id',
          body: payload,
          files: files),
    };

    final response = await _dataStore.client.patch(req);

    final rawMessage = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        await _marshaller.serializers.message.normalize(response.body),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) =>
        throw HttpException(response.bodyString),
      _ => throw Exception(
          'Unknown status code: ${response.statusCode} ${response.bodyString}')
    };

    final message = await _marshaller.serializers.message.serialize(rawMessage);
    completer.complete(message as T);

    return completer.future;
  }

  @override
  Future<void> pin(Snowflake channelId, Snowflake id) async {
    final req = Request.json(endpoint: '/channels/$channelId/pins/$id');
    await _dataStore.client.put(req);
  }

  @override
  Future<void> unpin(Snowflake channelId, Snowflake id) async {
    final req = Request.json(endpoint: '/channels/$channelId/pins/$id');
    await _dataStore.client.delete(req);
  }

  @override
  Future<void> crosspost(Snowflake channelId, Snowflake id) async {
    final req =
        Request.json(endpoint: '/channels/$channelId/messages/$id/crosspost');
    await _dataStore.client.post(req);
  }

  @override
  Future<void> delete(Snowflake channelId, Snowflake id) async {
    final req = Request.json(endpoint: '/channels/$channelId/messages/$id');
    await _dataStore.client.delete(req);
  }

  @override
  Future<T> send<T extends Message>(
      String? guildId, String channelId, MessageBuilder builder) async {
    final (components, files) = makeAttachmentFromBuilder(builder);

    final payload = {
      'flags': MessageFlagType.isComponentV2.value,
      'components': components
    };
    final req = switch (files.isEmpty) {
      true =>
        Request.json(endpoint: '/channels/$channelId/messages', body: payload),
      false => Request.formData(
          endpoint: '/channels/$channelId/messages',
          body: payload,
          files: files),
    };

    final response = await _dataStore.client.post(req);

    final message = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        await _marshaller.serializers.message.normalize(response.body),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) =>
        throw HttpException(response.bodyString),
      _ => throw Exception(
          'Unknown status code: ${response.statusCode} ${response.bodyString}')
    };

    return _marshaller.serializers.message.serialize(message) as Future<T>;
  }

  @override
  Future<R> reply<T extends Channel, R extends Message>(
      Snowflake id, Snowflake channelId, MessageBuilder builder) async {
    final (components, files) = makeAttachmentFromBuilder(builder);

    final payload = {
      'flags': MessageFlagType.isComponentV2.value,
      'components': components,
      'message_reference': {'message_id': id, 'channel_id': channelId}
    };

    final req = Request.auto(
      endpoint: '/channels/$channelId/messages',
      body: payload,
      files: files,
    );

    final result = await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.post);

    final raw = await _marshaller.serializers.message.normalize(result);
    return _marshaller.serializers.message.serialize(raw) as Future<R>;
  }

  @override
  Future<T> sendPoll<T extends Message>(String channelId, Poll poll) async {
    final completer = Completer<T>();
    final req = Request.json(
        endpoint: '/channels/$channelId/messages',
        body: {'poll': _marshaller.serializers.poll.deserialize(poll)});
    final response = await _dataStore.client.post(req);

    final message = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        await _marshaller.serializers.message.normalize(response.body),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) =>
        throw HttpException(response.bodyString),
      _ => throw Exception(
          'Unknown status code: ${response.statusCode} ${response.bodyString}')
    };

    final serializedMessage =
        await _marshaller.serializers.message.serialize(message);

    completer.complete(serializedMessage as T);

    return completer.future;
  }

  @override
  Future<PollAnswerVote> getPollVotes(Snowflake? serverId, Snowflake channelId,
      Snowflake messageId, int answerId) async {
    final completer = Completer<PollAnswerVote>();

    final req = Request.json(
        endpoint:
            '/channels/${channelId.value}/polls/${messageId.value}/answers/$answerId');
    final response = await _dataStore.client.get(req);

    response.body['id'] = answerId;
    response.body['message_id'] = messageId.value;
    response.body['channel_id'] = channelId.value;
    response.body['server_id'] = serverId?.value;

    final answerPayload = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        await _marshaller.serializers.pollAnswerVote.normalize(response.body),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) =>
        throw HttpException(response.bodyString),
      _ => throw Exception(
          'Unknown status code: ${response.statusCode} ${response.bodyString}')
    };

    final answer =
        await _marshaller.serializers.pollAnswerVote.serialize(answerPayload);

    completer.complete(answer);
    return completer.future;
  }
}
