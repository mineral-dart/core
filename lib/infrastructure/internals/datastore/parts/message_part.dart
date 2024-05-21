import 'dart:async';

import 'package:mineral/api/common/message.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store_part.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';
import 'package:mineral/infrastructure/services/http/http_client_status.dart';

final class MessagePart implements DataStorePart {
  final KernelContract _kernel;

  HttpClientStatus get status => _kernel.dataStore.client.status;

  MessagePart(this._kernel);

  Future<Message> getMessage(Snowflake messageId, Snowflake channelId, { Snowflake? serverId }) async {
    final cachedRawMessage = await _kernel.marshaller.cache.get(messageId);
    if (cachedRawMessage != null) {
      cachedRawMessage['channel_id'] = channelId.value;
      return _kernel.marshaller.serializers.message.serialize(cachedRawMessage);
    }

    final [messageResponse] = await Future.wait([
      _kernel.dataStore.client.get('/channels/$channelId/messages/$messageId')
    ]);

    messageResponse.body['guild_id'] = serverId?.value;

    final message = await _kernel.marshaller.serializers.message.serialize(messageResponse.body);

    await Future.wait([
      _kernel.marshaller.cache.put(messageId, messageResponse.body),
    ]);

    return message;
  }
}
