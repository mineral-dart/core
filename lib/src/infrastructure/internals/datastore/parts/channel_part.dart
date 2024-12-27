import 'dart:async';
import 'dart:io';

import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/api/common/channel.dart';
import 'package:mineral/src/api/common/components/message_component.dart';
import 'package:mineral/src/api/common/embed/message_embed.dart';
import 'package:mineral/src/api/common/message.dart';
import 'package:mineral/src/api/common/polls/poll.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/private/channels/private_channel.dart';
import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/api/server/channels/thread_channel.dart';
import 'package:mineral/src/domains/commons/utils/helper.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/http/discord_header.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';
import 'package:mineral/src/infrastructure/services/http/http_request_option.dart';

final class ChannelPart implements ChannelPartContract {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  @override
  Future<Map<Snowflake, T>> fetch<T extends Channel>(String serverId, bool force) async {
    final completer = Completer<Map<Snowflake, T>>();
    final response = await _dataStore.client.get('/guilds/$serverId/channels');

    final rawChannels = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) => await Future.wait(List.from(response.body)
          .map((e) async => await _marshaller.serializers.channels.normalize(e))),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}'),
    };

    final channels = await Future.wait(rawChannels.map((element) async {
      final channel = await _marshaller.serializers.channels.serialize(element);
      await _marshaller.cache.put(_marshaller.cacheKey.channel(channel.id.value), element);

      return channel;
    }));

    completer.complete(channels.asMap().map((_, value) => MapEntry(value.id, value as T)));
    return completer.future;
  }

  @override
  Future<T?> get<T extends Channel>(String id, bool force) async {
    final Completer<T> completer = Completer<T>();
    final String key = _marshaller.cacheKey.channel(id);

    final cachedChannel = await _marshaller.cache.get(key);
    if (!force && cachedChannel != null) {
      final channel = await _marshaller.serializers.channels.serialize(cachedChannel) as T;
      completer.complete(channel);

      return completer.future;
    }

    final response = await _dataStore.client.get('/channels/$id');
    final channel = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        await _marshaller.serializers.channels.normalize(response.body),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}')
    };

    completer.complete(await _marshaller.serializers.channels.serialize(channel) as T);

    return completer.future;
  }

  @override
  Future<ThreadChannel?> getThread(Snowflake id) async {
    final String key = _marshaller.cacheKey.thread(id.value);

    final cachedThread = await _marshaller.cache.get(key);
    if (cachedThread != null) {
      return _marshaller.serializers.thread.serialize(cachedThread);
    }

    final response = await _dataStore.client.get('/channels/$id');
    final rawThread = await _marshaller.serializers.thread.normalize(response.body);
    final thread = await _marshaller.serializers.thread.serialize(rawThread);

    return thread;
  }

  @override
  Future<T?> createServerChannel<T extends Channel>(
      {required Snowflake id,
      required Map<String, dynamic> payload,
      required String? reason}) async {
    final response = await _dataStore.client.post('/guilds/$id/channels',
        body: payload,
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    final Channel channel = await serializeChannelResponse(response);

    return channel as T?;
  }

  @override
  Future<PrivateChannel?> createPrivateChannel(
      {required Snowflake id, required Snowflake recipientId}) async {
    final response =
        await _dataStore.client.post('/users/@me/channels', body: {'recipient_id': recipientId});

    final Channel channel = await serializeChannelResponse(response);

    return channel as PrivateChannel?;
  }

  @override
  Future<T?> updateChannel<T extends Channel>(
      {required Snowflake id,
      required Map<String, dynamic> payload,
      required String? reason}) async {
    final response = await _dataStore.client.patch('/channels/$id',
        body: payload,
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    final Channel channel = await serializeChannelResponse(response);

    return channel as T?;
  }

  @override
  Future<void> deleteChannel(Snowflake id, String? reason) async {
    final response = await _dataStore.client.delete('/channels/$id',
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    return switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) => _marshaller.cache.remove(id.value),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode}'),
    };
  }

  @override
  Future<T> createMessage<T extends Message>(
      Snowflake? guildId,
      Snowflake channelId,
      String? content,
      List<MessageEmbed>? embeds,
      Poll? poll,
      List<MessageComponent>? components) async {
    final response = await _dataStore.client.post('/channels/$channelId/messages', body: {
      'content': content,
      'embeds': await Helper.createOrNullAsync(
          field: embeds,
          fn: () async => embeds?.map(_marshaller.serializers.embed.deserialize).toList()),
      'poll': await Helper.createOrNullAsync(
          field: poll, fn: () async => _marshaller.serializers.poll.deserialize(poll!)),
      'components': components?.map((e) => e.toJson()).toList(),
    });

    final channel = await _dataStore.channel.get(channelId.value, false);
    final serializer = switch (channel) {
      ServerChannel() => _marshaller.serializers.serverMessage,
      PrivateChannel() => _marshaller.serializers.privateMessage,
      _ => throw Exception('Unknown channel type: $channel'),
    } as SerializerContract<T>;

    final payload = await serializer.normalize({
      ...response.body,
      'server_id': guildId,
    });

    return serializer.serialize(payload);
  }

  @override
  Future<T> serializeChannelResponse<T extends Channel>(Response response) async {
    return switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) => () async {
          final payload = await _marshaller.serializers.channels.normalize(response.body);
          final channel = await _marshaller.serializers.channels.serialize(payload);

          if (channel is ServerChannel) {
            await _updateCacheFromChannelServer(channel.id, channel, payload);
          }

          return channel as T?;
        },
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}'),
    } as Future<T>;
  }

  Future<void> _updateCacheFromChannelServer(
      Snowflake id, ServerChannel channel, Map<String, dynamic> rawChannel) async {
    final server = await _dataStore.server.get(rawChannel['guild_id'], true);

    final rawServer = await _marshaller.serializers.server.deserialize(server);

    await _marshaller.cache.putMany({
      _marshaller.cacheKey.server(server.id.value): rawServer,
    });
  }
}
