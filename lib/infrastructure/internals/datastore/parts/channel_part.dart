import 'dart:async';
import 'dart:io';

import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/message.dart';
import 'package:mineral/api/common/polls/poll.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/infrastructure/commons/helper.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store_part.dart';
import 'package:mineral/infrastructure/internals/http/discord_header.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';
import 'package:mineral/infrastructure/services/http/http_client_status.dart';
import 'package:mineral/infrastructure/services/http/http_request_option.dart';
import 'package:mineral/infrastructure/services/http/response.dart';

final class ChannelPart implements DataStorePart {
  final KernelContract _kernel;

  HttpClientStatus get status => _kernel.dataStore.client.status;

  ChannelPart(this._kernel);

  Future<T?> getChannel<T extends Channel>(Snowflake id, { Snowflake? serverId }) async {
    final String key = serverId != null
        ? 'server-$serverId/channel-$id'
        : 'channel-$id';

    final cachedChannel = await _kernel.marshaller.cache.get(key);
    if (cachedChannel != null) {
      return _kernel.marshaller.serializers.channels.serializeCache(cachedChannel) as Future<T?>;
    }

    final response = await _kernel.dataStore.client.get('/channels/$id');
    final Channel? channel = await serializeChannelResponse(response);

    _putInCache(channel, id, response);

    return channel as T?;
  }

  Future<T?> createServerChannel<T extends Channel>(
      {required Snowflake id,
      required Map<String, dynamic> payload,
      required String? reason}) async {
    final response = await _kernel.dataStore.client.post('/guilds/$id/channels',
        body: payload,
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    final Channel? channel = await serializeChannelResponse(response);
    _putInCache(channel, id, response);

    return channel as T?;
  }

  Future<PrivateChannel?> createPrivateChannel(
      {required Snowflake id, required Snowflake recipientId}) async {
    final response =
        await _kernel.dataStore.client.post('/users/@me/channels', body: {'recipient_id': recipientId});

    final Channel? channel = await serializeChannelResponse(response);
    _putInCache(channel, id, response);

    return channel as PrivateChannel?;
  }

  Future<T?> updateChannel<T extends Channel>(
      {required Snowflake id,
      required Map<String, dynamic> payload,
      required String? reason}) async {
    final response = await _kernel.dataStore.client.patch('/channels/$id',
        body: payload,
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    final Channel? channel = await serializeChannelResponse(response);
    _putInCache(channel, id, response);

    return channel as T?;
  }

  Future<void> deleteChannel(Snowflake id, String? reason) async {
    final response = await _kernel.dataStore.client.delete('/channels/$id',
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    return switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) => _kernel.marshaller.cache.remove(id.value),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode}'),
    };
  }

  Future<T> createMessage<T extends Message>(Snowflake? guildId, Snowflake channelId,
      String? content, List<MessageEmbed>? embeds, Poll? poll) async {
    final response = await _kernel.dataStore.client.post('/channels/$channelId/messages', body: {
      'content': content,
      'embeds': await Helper.createOrNullAsync(
          field: embeds,
          fn: () async =>
              embeds?.map(_kernel.marshaller.serializers.embed.deserialize).toList()),
      'poll': await Helper.createOrNullAsync(
          field: poll, fn: () async => _kernel.marshaller.serializers.poll.deserialize(poll!))
    });

    final message = await switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) => _kernel.marshaller.serializers.message
          .serializeRemote({...response.body, 'guild_id': guildId}),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode}'),
    };

    await _kernel.marshaller.cache.put(message.id.value, {...response.body, 'guild_id': guildId});

    return message as T;
  }

  Future<T?> serializeChannelResponse<T extends Channel>(Response response) {
    return switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        _kernel.marshaller.serializers.channels.serializeRemote(response.body),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}'),
    } as Future<T?>;
  }

  Future<void> _putInCache(Channel? channel, Snowflake id, Response response) async {
    switch (channel) {
      case ServerChannel():
        _updateCacheFromChannelServer(id, channel, response.body);
      case PrivateChannel():
        _kernel.marshaller.cache.put('channel-${channel.id}', response.body);
      default:
        throw Exception('Unknown channel type: $channel');
    }
  }

  Future<void> _updateCacheFromChannelServer(
      Snowflake id, ServerChannel channel, Map<String, dynamic> rawChannel) async {
    final server = await _kernel.dataStore.server.getServer(rawChannel['guild_id']);
    server.channels.list[channel.id] = channel;

    final rawServer = await _kernel.marshaller.serializers.server.deserialize(server);

    await Future.wait([
      _kernel.marshaller.cache.put('server-${server.id}', rawServer),
      _kernel.marshaller.cache.put('server-${server.id}/channel-${channel.id}', rawChannel)
    ]);
  }
}
