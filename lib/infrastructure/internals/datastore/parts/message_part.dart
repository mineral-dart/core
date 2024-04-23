import 'dart:async';

import 'package:mineral/api/common/message.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/application/http/http_client_status.dart';
import 'package:mineral/domains/data_store/data_store.dart';
import 'package:mineral/domains/data_store/data_store_part.dart';

final class MessagePart implements DataStorePart {
  final DataStore _dataStore;

  HttpClientStatus get status => _dataStore.client.status;

  MessagePart(this._dataStore);

  Future<Message> getMessage(Snowflake messageId, Snowflake channelId, { Snowflake? serverId }) async {
    final cachedRawMessage = await _dataStore.marshaller.cache.get(messageId);
    if (cachedRawMessage != null) {
      cachedRawMessage['channel_id'] = channelId.value;
      return _dataStore.marshaller.serializers.message.serialize(cachedRawMessage);
    }

    final [messageResponse] = await Future.wait([
      _dataStore.client.get('/channels/$channelId/messages/$messageId')
    ]);

    messageResponse.body['guild_id'] = serverId?.value;

    final message = await _dataStore.marshaller.serializers.message.serialize(messageResponse.body);

    await Future.wait([
      _dataStore.marshaller.cache.put(messageId, messageResponse.body),
    ]);

    return message;
  }
}
