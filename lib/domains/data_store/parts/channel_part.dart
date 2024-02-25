import 'dart:async';

import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/domains/data_store/data_store.dart';
import 'package:mineral/domains/data_store/data_store_part.dart';

final class ChannelPart implements DataStorePart {
  final DataStore _dataStore;

  ChannelPart(this._dataStore);

  Future<Channel?> getChannel<T extends Channel>(Snowflake id) async {
    final response = await _dataStore.client.get('/channels/$id');
    final channel = _dataStore.marshaller.serializers.channels.serialize(response.body);

    return channel;
  }
}
