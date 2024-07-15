import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/infrastructure/commons/helper.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store_part.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';
import 'package:mineral/infrastructure/services/http/http_client_status.dart';
import 'package:mineral/infrastructure/services/http/response.dart';

final class ServerMessagePart implements DataStorePart {
  final KernelContract _kernel;

  HttpClientStatus get status => _kernel.dataStore.client.status;

  ServerMessagePart(this._kernel);

  Future<ServerMessage?> update({ required Snowflake id, required Snowflake channelId, required Map<String, dynamic> payload }) async {
    final response = await _kernel.dataStore.client.patch('/channels/$channelId/messages/$id', body: payload);

    final ServerMessage? serverMessage = await serializeResponse(response);

    if (serverMessage != null) {
      final rawServerMessage = _kernel.marshaller.serializers.message.deserialize(response.body);
      await _kernel.marshaller.cache.put(serverMessage.id, rawServerMessage);
    }

    return serverMessage;
  }

  Future<ServerMessage?> reply({ required Snowflake id, required Snowflake channelId, String? content, List<MessageEmbed>? embeds }) async {
    final response = await _kernel.dataStore.client.post('/channels/$channelId/messages', body: {
      'content': content,
      'embeds': await Helper.createOrNullAsync(
          field: embeds,
          fn: () async =>
              embeds?.map(_kernel.marshaller.serializers.embed.deserialize).toList()),
      'message_reference': {
        'message_id': id,
        'channel_id': channelId
      }
    });

    final ServerMessage? serverMessage = await serializeResponse(response);

    if (serverMessage != null) {
      final rawServerMessage = _kernel.marshaller.serializers.message.deserialize(response.body);
      await _kernel.marshaller.cache.put(serverMessage.id, rawServerMessage);
    }

    return serverMessage;
  }

  Future<void> pin({ required Snowflake id, required Snowflake channelId }) async {
    await _kernel.dataStore.client.put('/channels/$channelId/pins/$id');
  }

  Future<void> unpin({ required Snowflake id, required Snowflake channelId }) async {
    await _kernel.dataStore.client.delete('/channels/$channelId/pins/$id');
  }

  Future<void> crosspost({required Snowflake id, required Snowflake channelId}) async {
    await _kernel.dataStore.client.post('/channels/$channelId/messages/$id/crosspost');
  }

  Future<void> pin({ required Snowflake id, required Snowflake channelId }) async {
    await _kernel.dataStore.client.put('/channels/$channelId/pins/$id');
  }

  Future<void> delete({ required Snowflake id, required Snowflake channelId }) async {
    await _kernel.dataStore.client.delete('/channels/$channelId/messages/$id');
  }

  Future<ServerMessage?> serializeResponse(Response response) async {
    return switch(response.statusCode) {
      int() when (status.isSuccess(response.statusCode)) =>
        _kernel.marshaller.serializers.message.serialize(response.body),
      int() when (status.isError(response.statusCode)) =>
        throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}')
    } as Future<ServerMessage?>;
  }
}
