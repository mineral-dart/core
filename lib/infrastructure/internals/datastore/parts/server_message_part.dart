import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/infrastructure/commons/helper.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store_part.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';
import 'package:mineral/infrastructure/services/http/http_client_status.dart';

final class ServerMessagePart implements DataStorePart {
  final KernelContract _kernel;

  HttpClientStatus get status => _kernel.dataStore.client.status;

  ServerMessagePart(this._kernel);

  Future<void> update({ required Snowflake id, required Snowflake channelId, required Map<String, dynamic> payload }) async {
    await _kernel.dataStore.client.patch('/channels/$channelId/messages/$id', body: payload);
  }

  Future<void> reply({ required Snowflake id, required Snowflake channelId, String? content, List<MessageEmbed>? embeds }) async {
    await _kernel.dataStore.client.post('/channels/$channelId/messages', body: {
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
  }

  Future<void> delete({ required Snowflake id, required Snowflake channelId }) async {
    await _kernel.dataStore.client.delete('/channels/$channelId/messages/$id');
  }
}
