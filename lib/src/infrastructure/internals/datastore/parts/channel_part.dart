import 'dart:async';
import 'dart:io';

import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/api/common/channel.dart';
import 'package:mineral/src/api/common/components/message_component.dart';
import 'package:mineral/src/api/common/embed/message_embed.dart';
import 'package:mineral/src/api/common/message.dart';
import 'package:mineral/src/api/common/polls/poll.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/private/channels/private_channel.dart';
import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/api/server/channels/server_text_channel.dart';
import 'package:mineral/src/api/server/channels/thread_channel.dart';
import 'package:mineral/src/domains/commons/utils/helper.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store_part.dart';
import 'package:mineral/src/infrastructure/internals/http/discord_header.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';
import 'package:mineral/src/infrastructure/services/http/http_request_option.dart';

final class ChannelPart implements DataStorePart {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  Future<T?> getChannel<T extends Channel>(Snowflake id) async {
    final String key = _marshaller.cacheKey.channel(id);

    final cachedChannel = await _marshaller.cache.get(key);
    if (cachedChannel != null) {
      return _marshaller.serializers.channels.serialize(cachedChannel)
          as Future<T?>;
    }

    final threadKey = _marshaller.cacheKey.thread(id);
    final cachedThread = await _marshaller.cache.get(threadKey);

    if (cachedThread != null) {
      return _marshaller.serializers.thread.serialize(cachedThread)
          as Future<T?>;
    }

    final response = await _dataStore.client.get('/channels/$id');
    final T? channel = await serializeChannelResponse<T>(response);

    return channel;
  }

  Future<ThreadChannel?> getThread(Snowflake id) async {
    final String key = _marshaller.cacheKey.thread(id);

    final cachedThread = await _marshaller.cache.get(key);
    if (cachedThread != null) {
      return _marshaller.serializers.thread.serialize(cachedThread);
    }

    final response = await _dataStore.client.get('/channels/$id');
    final rawThread =
        await _marshaller.serializers.thread.normalize(response.body);
    final thread = await _marshaller.serializers.thread.serialize(rawThread);
    final parentChannel =
        await getChannel(Snowflake(thread.channelId)) as ServerTextChannel;

    thread
      ..server = await _dataStore.server.getServer(rawThread['guild_id'])
      ..parentChannel = parentChannel;

    return thread;
  }

  Future<T?> createServerChannel<T extends Channel>(
      {required Snowflake id,
      required Map<String, dynamic> payload,
      required String? reason}) async {
    final response = await _dataStore.client.post('/guilds/$id/channels',
        body: payload,
        option: HttpRequestOptionImpl(
            headers: {DiscordHeader.auditLogReason(reason)}));

    final Channel? channel = await serializeChannelResponse(response);

    return channel as T?;
  }

  Future<PrivateChannel?> createPrivateChannel(
      {required Snowflake id, required Snowflake recipientId}) async {
    final response = await _dataStore.client
        .post('/users/@me/channels', body: {'recipient_id': recipientId});

    final Channel? channel = await serializeChannelResponse(response);

    return channel as PrivateChannel?;
  }

  Future<T?> updateChannel<T extends Channel>(
      {required Snowflake id,
      required Map<String, dynamic> payload,
      required String? reason}) async {
    final response = await _dataStore.client.patch('/channels/$id',
        body: payload,
        option: HttpRequestOptionImpl(
            headers: {DiscordHeader.auditLogReason(reason)}));

    final Channel? channel = await serializeChannelResponse(response);

    return channel as T?;
  }

  Future<void> deleteChannel(Snowflake id, String? reason) async {
    final response = await _dataStore.client.delete('/channels/$id',
        option: HttpRequestOptionImpl(
            headers: {DiscordHeader.auditLogReason(reason)}));

    return switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        _marshaller.cache.remove(id.value),
      int() when status.isError(response.statusCode) =>
        throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode}'),
    };
  }

  Future<T> createMessage<T extends Message>(
      Snowflake? guildId,
      Snowflake channelId,
      String? content,
      List<MessageEmbed>? embeds,
      Poll? poll,
      List<MessageComponent>? components) async {
    final response =
        await _dataStore.client.post('/channels/$channelId/messages', body: {
      'content': content,
      'embeds': await Helper.createOrNullAsync(
          field: embeds,
          fn: () async =>
              embeds?.map(_marshaller.serializers.embed.deserialize).toList()),
      'poll': await Helper.createOrNullAsync(
          field: poll,
          fn: () async => _marshaller.serializers.poll.deserialize(poll!)),
      'components': components?.map((e) => e.toJson()).toList(),
    });

    final channel = await _dataStore.channel.getChannel(channelId);
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

  Future<T?> serializeChannelResponse<T extends Channel>(
      Response response) async {
    return switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) => () async {
          final payload =
              await _marshaller.serializers.channels.normalize(response.body);
          final channel =
              await _marshaller.serializers.channels.serialize(payload);

          if (channel is ServerChannel) {
            await _updateCacheFromChannelServer(channel.id, channel, payload);
          }

          return channel as T?;
        },
      int() when status.isError(response.statusCode) =>
        throw HttpException(response.bodyString),
      _ => throw Exception(
          'Unknown status code: ${response.statusCode} ${response.bodyString}'),
    } as Future<T?>;
  }

  Future<void> _updateCacheFromChannelServer(Snowflake id,
      ServerChannel channel, Map<String, dynamic> rawChannel) async {
    final server = await _dataStore.server.getServer(rawChannel['guild_id']);
    server.channels.list[channel.id] = channel;

    final rawServer = await _marshaller.serializers.server.deserialize(server);

    await _marshaller.cache.putMany({
      _marshaller.cacheKey.server(server.id): rawServer,
    });
  }
}
