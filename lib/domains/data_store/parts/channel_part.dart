import 'dart:async';
import 'dart:io';

import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/application/http/http_request_option.dart';
import 'package:mineral/domains/data_store/data_store.dart';
import 'package:mineral/domains/data_store/data_store_part.dart';
import 'package:mineral/domains/http/discord_header.dart';

final class ChannelPart implements DataStorePart {
  final DataStore _dataStore;

  ChannelPart(this._dataStore);

  Future<Channel?> getChannel<T extends Channel>(Snowflake id) async {
    final response = await _dataStore.client.get('/channels/$id');

    final channel = await switch (response.statusCode) {
      int() when _dataStore.client.status.isSuccess(response.statusCode) =>
          _dataStore.marshaller.serializers.channels.serialize(response.body),
      int() when _dataStore.client.status.isError(response.statusCode) =>
      throw HttpException(response.body),
      _ => throw Exception('Unknown status code: ${response.statusCode}'),
    };

    _dataStore.marshaller.cache.put(channel?.id, response.body);
    return channel;
  }

  Future<Channel?> updateChannel<T extends Channel>(
      {required Snowflake id,
      required Map<String, dynamic> payload,
      required String? reason}) async {
    final response = await _dataStore.client.patch('/channels/$id',
        body: payload,
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    final channel = await switch (response.statusCode) {
      int() when _dataStore.client.status.isSuccess(response.statusCode) =>
        _dataStore.marshaller.serializers.channels.serialize(response.body),
      int() when _dataStore.client.status.isError(response.statusCode) =>
        throw HttpException(response.body),
      _ => throw Exception('Unknown status code: ${response.statusCode}'),
    };

    _dataStore.marshaller.cache.put(channel?.id, response.body);
    return channel;
  }

  Future<void> deleteChannel(Snowflake id, String? reason) async {
    final response = await _dataStore.client.delete('/channels/$id',
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    return switch (response.statusCode) {
      int() when _dataStore.client.status.isSuccess(response.statusCode) =>
        _dataStore.marshaller.cache.remove(id),
      int() when _dataStore.client.status.isError(response.statusCode) =>
        throw HttpException(response.body),
      _ => throw Exception('Unknown status code: ${response.statusCode}'),
    };
  }
}
