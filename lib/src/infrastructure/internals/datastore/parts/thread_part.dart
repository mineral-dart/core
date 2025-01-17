import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/api/server/channels/private_thread_channel.dart';
import 'package:mineral/src/api/server/channels/public_thread_channel.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/http/discord_header.dart';
import 'package:mineral/src/infrastructure/services/http/http_request_option.dart';

final class ThreadPart implements ThreadPartContract {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  @override
  Future<ThreadResult> fetchActives(String serverId) async {
    final completer = Completer<ThreadResult>();

    final result = await _dataStore.requestBucket
        .run<List>(() => _dataStore.client.get('/guilds/$serverId/threads/active'));

    final channels = await result.map((element) async {
      final raw = await _marshaller.serializers.channels.normalize(element);
      return _marshaller.serializers.channels.serialize(raw);
    }).wait;

    completer.complete(ThreadResult(
        channels.asMap().map((key, value) => MapEntry(value.id, value as ServerChannel))));

    return completer.future;
  }

  @override
  Future<Map<Snowflake, PublicThreadChannel>> fetchPublicArchived(String channelId) async {
    final completer = Completer<Map<Snowflake, PublicThreadChannel>>();

    final result = await _dataStore.requestBucket
        .run<List>(() => _dataStore.client.get('/channels/$channelId/archived/public'));

    final channels = await result.map((element) async {
      final raw = await _marshaller.serializers.channels.normalize(element);
      return _marshaller.serializers.channels.serialize(raw);
    }).wait;

    completer.complete(channels.asMap().map((key, value) => MapEntry(value.id, value as PublicThreadChannel)));

    return completer.future;
  }

  @override
  Future<Map<Snowflake, PrivateThreadChannel>> fetchPrivateArchived(String channelId) async {
    final completer = Completer<Map<Snowflake, PrivateThreadChannel>>();

    final result = await _dataStore.requestBucket
        .run<List>(() => _dataStore.client.get('/channels/$channelId/archived/private'));

    final channels = await result.map((element) async {
      final raw = await _marshaller.serializers.channels.normalize(element);
      return _marshaller.serializers.channels.serialize(raw);
    }).wait;

    completer.complete(channels.asMap().map((key, value) => MapEntry(value.id, value as PrivateThreadChannel)));

    return completer.future;
  }

  @override
  Future<T> createWithoutMessage<T extends ThreadChannel>(String? serverId, String? channelId, ThreadChannelBuilder builder,
      {String? reason}) async {
    final completer = Completer<T>();

    final result = await _dataStore.requestBucket.run<Map<String, dynamic>>(() => _dataStore.client
        .post('/channels/$channelId/threads',
            body: builder.build(),
            option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)})));

    final raw = await _marshaller.serializers.channels.normalize(result);
    final channel = await _marshaller.serializers.channels.serialize({
      ...raw,
      'guild_id': serverId,
    }) as T;

    completer.complete(channel);
    return completer.future;
  }

  @override
  Future<T> createFromMessage<T extends ThreadChannel>(String? serverId, String? channelId, String? messageId, ThreadChannelBuilder builder,
      {String? reason}) async {
    final completer = Completer<T>();

    final result = await _dataStore.requestBucket.run<Map<String, dynamic>>(() => _dataStore.client
        .post('/channels/$channelId/messages/$messageId/threads',
        body: builder.build(),
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)})));

    final raw = await _marshaller.serializers.channels.normalize(result);
    final channel = await _marshaller.serializers.channels.serialize({
      ...raw,
      'guild_id': serverId,
    }) as T;

    completer.complete(channel);
    return completer.future;
  }
}
