import 'dart:io';

import 'package:mineral/container.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/private/channels/private_channel.dart';
import 'package:mineral/src/api/private/private_message.dart';
import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/api/server/server_message.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store_part.dart';

final class MessagePart implements DataStorePart {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  Future<ServerMessage> getServerMessage(
      {required Snowflake messageId, required Snowflake channelId}) async {
    final messageCacheKey = _marshaller.cacheKey.message(channelId, channelId);
    final channelCacheKey = _marshaller.cacheKey.channel(channelId);

    final rawMessage = await _marshaller.cache.get(messageCacheKey);
    final rawChannel = await _marshaller.cache.getOrFail(channelCacheKey);
    final serverChannel = await _marshaller.serializers.channels
        .serialize(rawChannel) as ServerChannel;

    if (rawMessage != null) {
      final message =
          await _marshaller.serializers.serverMessage.serialize(rawMessage)
            ..channel = serverChannel;

      return message;
    }

    final response =
        await _dataStore.client.get('/channels/$channelId/messages/$messageId');
    if (status.isError(response.statusCode)) {
      throw HttpException(response.body);
    }

    final payload = await _marshaller.serializers.serverMessage.normalize({
      ...response.body,
      'server_id': serverChannel.serverId.value,
    });

    final serverMessage =
        await _marshaller.serializers.serverMessage.serialize(payload);

    serverMessage.channel = serverChannel;
    return serverMessage;
  }

  Future<PrivateMessage> getPrivateMessage(
      {required Snowflake messageId, required Snowflake channelId}) async {
    final messageCacheKey = _marshaller.cacheKey.message(channelId, channelId);
    final channelCacheKey = _marshaller.cacheKey.channel(channelId);

    final rawMessage = await _marshaller.cache.get(messageCacheKey);
    final rawChannel = await _marshaller.cache.getOrFail(channelCacheKey);
    final channel = await _marshaller.serializers.channels.serialize(rawChannel)
        as PrivateChannel;

    if (rawMessage != null) {
      final message =
          await _marshaller.serializers.privateMessage.serialize(rawMessage)
            ..channel = channel;

      return message;
    }

    final response =
        await _dataStore.client.get('/channels/$channelId/messages/$messageId');

    final payload =
        await _marshaller.serializers.serverMessage.normalize(response.body);
    final privateMessage =
        await _marshaller.serializers.privateMessage.serialize(payload);

    privateMessage.channel = channel;
    return privateMessage;
  }
}
