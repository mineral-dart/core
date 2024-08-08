import 'package:mineral/api/common/components/message_component.dart';
import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/infrastructure/commons/helper.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store_part.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';
import 'package:mineral/infrastructure/services/http/http_client_status.dart';

final class ServerMessagePart implements DataStorePart {
  final KernelContract _kernel;

  HttpClientStatus get status => _kernel.dataStore.client.status;

  ServerMessagePart(this._kernel);

  Future<ServerMessage> update({
    required Snowflake id,
    required Snowflake channelId,
    String? content,
    List<MessageEmbed>? embeds,
    List<MessageComponent>? components,
  }) async {
    final response = await _kernel.dataStore.client
        .patch('/channels/$channelId/messages/$id', body: {
      'content': content,
      'embeds': await Helper.createOrNullAsync(
          field: embeds,
          fn: () async => embeds
              ?.map(_kernel.marshaller.serializers.embed.deserialize)
              .toList()),
      'components': components?.map((c) => c.toJson()).toList()
    });

    final ServerMessage serverMessage = await _kernel
        .marshaller.serializers.message
        .serializeRemote(response.body);

    final serverKey = _kernel.marshaller.cacheKey.serverMessage(
        serverId: serverMessage.channel.server.id, messageId: serverMessage.id);
    final rawServerMessage =
        _kernel.marshaller.serializers.message.deserialize(response.body);

    await _kernel.marshaller.cache.put(serverKey, rawServerMessage);

    return serverMessage;
  }

  Future<ServerMessage> reply(
      {required Snowflake id,
      required Snowflake channelId,
      required Snowflake serverId,
      String? content,
      List<MessageEmbed>? embeds}) async {
    final response = await _kernel.dataStore.client
        .post('/channels/$channelId/messages', body: {
      'content': content,
      'embeds': await Helper.createOrNullAsync(
          field: embeds,
          fn: () async => embeds
              ?.map(_kernel.marshaller.serializers.embed.deserialize)
              .toList()),
      'message_reference': {'message_id': id, 'channel_id': channelId}
    });

    final server = await _kernel.dataStore.server.getServer(serverId);
    final channel = await _kernel.dataStore.channel
        .getChannel<ServerChannel>(channelId, serverId: serverId);
    final ServerMessage serverMessage =
        await _kernel.marshaller.serializers.message.serializeRemote({
      ...response.body,
      'guild_id': serverId,
    });

    if (channel != null) {
      channel.server = server;
      serverMessage.channel = channel;
    }

    final messageKey = _kernel.marshaller.cacheKey.serverMessage(
        serverId: serverMessage.channel.server.id, messageId: serverMessage.id);
    final rawServerMessage =
        await _kernel.marshaller.serializers.message.deserialize(serverMessage);

    await _kernel.marshaller.cache.put(messageKey, rawServerMessage);

    return serverMessage;
  }

  Future<void> pin(
      {required Snowflake id, required Snowflake channelId}) async {
    await _kernel.dataStore.client.put('/channels/$channelId/pins/$id');
  }

  Future<void> unpin(
      {required Snowflake id, required Snowflake channelId}) async {
    await _kernel.dataStore.client.delete('/channels/$channelId/pins/$id');
  }

  Future<void> crosspost(
      {required Snowflake id, required Snowflake channelId}) async {
    await _kernel.dataStore.client
        .post('/channels/$channelId/messages/$id/crosspost');
  }

  Future<void> delete(
      {required Snowflake id, required Snowflake channelId}) async {
    await _kernel.dataStore.client.delete('/channels/$channelId/messages/$id');
  }
}
