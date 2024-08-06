import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store_part.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';

final class MessagePart implements DataStorePart {
  final KernelContract _kernel;

  MessagePart(this._kernel);

  Future<ServerMessage> getServerMessage(
      {required Snowflake messageId, required Snowflake channelId}) async {
    final messageCacheKey =
        _kernel.marshaller.cacheKey.serverMessage(messageId: messageId, channelId: channelId);

    final message = await _kernel.marshaller.cache.get(messageCacheKey);
    if (message != null) {
      return _kernel.marshaller.serializers.serverMessage.serializeCache(message);
    }

    final response = await _kernel.dataStore.client.get('/channels/$channelId/messages/$messageId');

    final serverMessage =
        await _kernel.marshaller.serializers.serverMessage.serializeRemote(response.body);

    final channelCacheKey = _kernel.marshaller.cacheKey.channel(channelId);
    final rawChannel = await _kernel.marshaller.cache.getOrFail(channelCacheKey);
    serverMessage.channel =
        await _kernel.marshaller.serializers.channels.serializeCache(rawChannel) as ServerChannel;

    final rawMessage =
        await _kernel.marshaller.serializers.serverMessage.deserialize(serverMessage);

    await _kernel.marshaller.cache.put(messageCacheKey, rawMessage);

    return serverMessage;
  }

  Future<PrivateMessage> getPrivateMessage(
      {required Snowflake messageId, required Snowflake channelId}) async {
    final messageCacheKey =
        _kernel.marshaller.cacheKey.privateMessage(messageId: messageId, channelId: channelId);

    final message = await _kernel.marshaller.cache.get(messageCacheKey);
    if (message != null) {
      return _kernel.marshaller.serializers.privateMessage.serializeCache(message);
    }

    final response = await _kernel.dataStore.client.get('/channels/$channelId/messages/$messageId');

    final privateMessage =
        await _kernel.marshaller.serializers.privateMessage.serializeRemote(response.body);

    final channelCacheKey = _kernel.marshaller.cacheKey.channel(channelId);
    final rawChannel = await _kernel.marshaller.cache.getOrFail(channelCacheKey);
    privateMessage.channel =
        await _kernel.marshaller.serializers.channels.serializeCache(rawChannel) as PrivateChannel;

    final rawMessage =
        await _kernel.marshaller.serializers.privateMessage.deserialize(privateMessage);

    await _kernel.marshaller.cache.put(messageCacheKey, rawMessage);

    return privateMessage;
  }
}
