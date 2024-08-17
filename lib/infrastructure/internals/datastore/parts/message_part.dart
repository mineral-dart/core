import 'dart:io';

import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store_part.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';
import 'package:mineral/infrastructure/services/http/http_client_status.dart';

final class MessagePart implements DataStorePart {
  final KernelContract _kernel;

  HttpClientStatus get status => _kernel.dataStore.client.status;

  MessagePart(this._kernel);

  Future<ServerMessage> getServerMessage(
      {required Snowflake messageId, required Snowflake channelId}) async {
    final messageCacheKey = _kernel.marshaller.cacheKey.message(channelId, channelId);
    final channelCacheKey = _kernel.marshaller.cacheKey.channel(channelId);

    final rawMessage = await _kernel.marshaller.cache.get(messageCacheKey);
    final rawChannel = await _kernel.marshaller.cache.getOrFail(channelCacheKey);
    final serverChannel =
        await _kernel.marshaller.serializers.channels.serialize(rawChannel) as ServerChannel;

    if (rawMessage != null) {
      final message = await _kernel.marshaller.serializers.serverMessage.serialize(rawMessage)
        ..channel = serverChannel;

      return message;
    }

    final response = await _kernel.dataStore.client.get('/channels/$channelId/messages/$messageId');
    if (status.isError(response.statusCode)) {
      throw HttpException(response.body);
    }

    final payload = await _kernel.marshaller.serializers.serverMessage.normalize(response.body);
    final serverMessage = await _kernel.marshaller.serializers.serverMessage.serialize(payload);

    serverMessage.channel = serverChannel;
    return serverMessage;
  }

  Future<PrivateMessage> getPrivateMessage(
      {required Snowflake messageId, required Snowflake channelId}) async {
    final messageCacheKey = _kernel.marshaller.cacheKey.message(channelId, channelId);
    final channelCacheKey = _kernel.marshaller.cacheKey.channel(channelId);

    final rawMessage = await _kernel.marshaller.cache.get(messageCacheKey);
    final rawChannel = await _kernel.marshaller.cache.getOrFail(channelCacheKey);
    final channel = await _kernel.marshaller.serializers.channels.serialize(rawChannel) as PrivateChannel;

    if (rawMessage != null) {
      final message = await _kernel.marshaller.serializers.privateMessage.serialize(rawMessage)
        ..channel = channel;

      return message;
    }

    final response = await _kernel.dataStore.client.get('/channels/$channelId/messages/$messageId');

    final payload = await _kernel.marshaller.serializers.serverMessage.normalize(response.body);
    final privateMessage = await _kernel.marshaller.serializers.privateMessage.serialize(payload);

    privateMessage.channel = channel;
    return privateMessage;
  }
}
