import 'dart:async';
import 'dart:io';

import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/application/http/http_client_status.dart';
import 'package:mineral/application/http/http_request_option.dart';
import 'package:mineral/application/http/response.dart';
import 'package:mineral/domains/data_store/data_store.dart';
import 'package:mineral/domains/data_store/data_store_part.dart';
import 'package:mineral/domains/http/discord_header.dart';

final class ChannelPart implements DataStorePart {
  final DataStore _dataStore;

  HttpClientStatus get status => _dataStore.client.status;

  ChannelPart(this._dataStore);

  Future<T?> getChannel<T extends Channel>(Snowflake id) async {
    final cachedChannel = await _dataStore.marshaller.cache.get(id);
    print(cachedChannel);
    if (cachedChannel != null) {
      return _dataStore.marshaller.serializers.channels.serialize(cachedChannel, cache: true) as Future<T?>;
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
      int() when status.isError(response.statusCode) => throw HttpException(response.body),
      _ => throw Exception('Unknown status code: ${response.statusCode}'),
    };
  }

  Future<T?> serializeChannelResponse<T extends Channel>(Response response) {
    return switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        _dataStore.marshaller.serializers.channels.serialize(response.body),
      int() when status.isError(response.statusCode) => throw HttpException(response.body),
      _ => throw Exception('Unknown status code: ${response.statusCode}'),
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
