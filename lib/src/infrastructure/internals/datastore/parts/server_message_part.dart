import 'package:mineral/src/api/common/components/message_component.dart';
import 'package:mineral/src/api/common/embed/message_embed.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/api/server/server_message.dart';
import 'package:mineral/src/infrastructure/commons/helper.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store_part.dart';
import 'package:mineral/src/infrastructure/kernel/kernel.dart';
import 'package:mineral/src/infrastructure/services/http/http_client_status.dart';

final class ServerMessagePart implements DataStorePart {
  final KernelContract _kernel;

  HttpClientStatus get status => _kernel.dataStore.client.status;

  ServerMessagePart(this._kernel);

  Future<ServerMessage> update({
    required Snowflake id,
    required Snowflake channelId,
    required Snowflake serverId,
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

    final server = await _kernel.dataStore.server.getServer(serverId);
    final channel =
        await _kernel.dataStore.channel.getChannel<ServerChannel>(channelId);

    final Map<String, dynamic> serverMessage = await _kernel
        .marshaller.serializers.serverMessage
        .normalize(response.body);
    final message = await _kernel.marshaller.serializers.serverMessage
        .serialize(serverMessage);

    if (channel != null) {
      channel.server = server;
      message.channel = channel;
    }

    return message;
  }

  Future<ServerMessage> reply(
      {required Snowflake id,
      required Snowflake channelId,
      required Snowflake serverId,
      String? content,
      List<MessageEmbed>? embeds,
      List<MessageComponent>? components}) async {
    final response = await _kernel.dataStore.client
        .post('/channels/$channelId/messages', body: {
      'content': content,
      'embeds': Helper.createOrNull(
              field: embeds,
              fn: () =>
                  embeds?.map(_kernel.marshaller.serializers.embed.deserialize))
          ?.toList(),
      'components': components?.map((c) => c.toJson()).toList(),
      'message_reference': {'message_id': id, 'channel_id': channelId}
    });

    final server = await _kernel.dataStore.server.getServer(serverId);
    final channel =
        await _kernel.dataStore.channel.getChannel<ServerChannel>(channelId);

    final Map<String, dynamic> rawMessage =
        await _kernel.marshaller.serializers.serverMessage.normalize({
      ...response.body,
      'server_id': serverId,
    });

    final ServerMessage message = await _kernel
        .marshaller.serializers.serverMessage
        .serialize(rawMessage);

    if (channel != null) {
      channel.server = server;
      message.channel = channel;
    }

    return message;
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
