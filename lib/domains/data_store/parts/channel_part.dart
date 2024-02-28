import 'dart:async';

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
    return _dataStore.marshaller.serializers.channels.serialize(response.body);
  }

  Future<Channel?> updateChannel<T extends Channel>(
      {required Snowflake id,
      required Map<String, dynamic> payload,
      required String? reason}) async {
    final response = await _dataStore.client.patch('/channels/$id',
        body: payload,
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    return _dataStore.marshaller.serializers.channels.serialize(response.body);
  }

  Future<void> deleteChannel(Snowflake id, String? reason) async {
    await _dataStore.client.delete('/channels/$id',
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));
  }
}
