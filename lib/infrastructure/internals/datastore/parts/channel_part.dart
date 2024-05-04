import 'dart:async';
import 'dart:io';

import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/message.dart';
import 'package:mineral/api/common/polls/poll.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/infrastructure/internals/http/discord_header.dart';
import 'package:mineral/domains/shared/helper.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store_part.dart';
import 'package:mineral/infrastructure/services/http/http_client_status.dart';
import 'package:mineral/infrastructure/services/http/http_request_option.dart';
import 'package:mineral/infrastructure/services/http/response.dart';

final class ChannelPart implements DataStorePart {
  final DataStore _dataStore;

  HttpClientStatus get status => _dataStore.client.status;

  ChannelPart(this._dataStore);

  Future<T?> getChannel<T extends Channel>(Snowflake id) async {
    final cachedChannel = await _dataStore.marshaller.cache.get(id);
    if (cachedChannel != null) {
      return _dataStore.marshaller.serializers.channels.serialize(cachedChannel) as Future<T?>;
    }

    final response = await _dataStore.client.get('/channels/$id');
    final Channel? channel = await serializeChannelResponse(response);

    _putInCache(channel, id, response);

    return channel as T?;
  }

  Future<T?> createServerChannel<T extends Channel>(
      {required Snowflake id,
      required Map<String, dynamic> payload,
      required String? reason}) async {
    final response = await _dataStore.client.post('/guilds/$id/channels',
        body: payload,
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    final Channel? channel = await serializeChannelResponse(response);
    _putInCache(channel, id, response);

    return channel as T?;
  }

  Future<PrivateChannel?> createPrivateChannel(
      {required Snowflake id, required Snowflake recipientId}) async {
    final response =
        await _dataStore.client.post('/users/@me/channels', body: {'recipient_id': recipientId});

    final Channel? channel = await serializeChannelResponse(response);
    _putInCache(channel, id, response);

    return channel as PrivateChannel?;
  }

  Future<T?> updateChannel<T extends Channel>(
      {required Snowflake id,
      required Map<String, dynamic> payload,
      required String? reason}) async {
    final response = await _dataStore.client.patch('/channels/$id',
        body: payload,
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    final Channel? channel = await serializeChannelResponse(response);
    _putInCache(channel, id, response);

    return channel as T?;
  }

  Future<void> deleteChannel(Snowflake id, String? reason) async {
    final response = await _dataStore.client.delete('/channels/$id',
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    return switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) => _dataStore.marshaller.cache.remove(id),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode}'),
    };
  }

  Future<T> createMessage<T extends Message>(Snowflake? guildId, Snowflake channelId,
      String? content, List<MessageEmbed>? embeds, Poll? poll) async {
    final response = await _dataStore.client.post('/channels/$channelId/messages', body: {
      'content': content,
      'embeds': await Helper.createOrNullAsync(
          field: embeds,
          fn: () async =>
              embeds?.map(_dataStore.marshaller.serializers.embed.deserialize).toList()),
      'poll': await Helper.createOrNullAsync(
          field: poll, fn: () async => _dataStore.marshaller.serializers.poll.deserialize(poll!))
    });

    final message = await switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) => _dataStore.marshaller.serializers.message
          .serialize({...response.body, 'guild_id': guildId}),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode}'),
    };

    await _dataStore.marshaller.cache.put(message.id, {...response.body, 'guild_id': guildId});

    return message as T;
  }

  Future<T?> serializeChannelResponse<T extends Channel>(Response response) {
    return switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        _dataStore.marshaller.serializers.channels.serialize(response.body),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}'),
    } as Future<T?>;
  }

  Future<void> _putInCache(Channel? channel, Snowflake id, Response response) async {
    switch (channel) {
      case ServerChannel():
        _updateCacheFromChannelServer(id, channel, response.body);
      case PrivateChannel():
        _dataStore.marshaller.cache.put(channel.id, response.body);
      default:
        throw Exception('Unknown channel type: $channel');
    }
  }

  Future<void> _updateCacheFromChannelServer(
      Snowflake id, ServerChannel channel, Map<String, dynamic> rawChannel) async {
    final server = await _dataStore.server.getServer(rawChannel['guild_id']);
    server.channels.list[channel.id] = channel;

    final rawServer = await _dataStore.marshaller.serializers.server.deserialize(server);

    await Future.wait([
      _dataStore.marshaller.cache.put(server.id, rawServer),
      _dataStore.marshaller.cache.put(channel.id, rawChannel)
    ]);
  }
}
