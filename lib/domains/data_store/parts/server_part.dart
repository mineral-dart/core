import 'dart:async';

import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/data_store/data_store.dart';
import 'package:mineral/domains/data_store/data_store_part.dart';

final class ServerPart implements DataStorePart {
  final DataStore _dataStore;

  ServerPart(this._dataStore);

  FutureOr<Server> getServer(Snowflake id) async {
    final [server, channels, members] = await Future.wait([
      _dataStore.client.get('/guilds/$id'),
      _dataStore.client.get('/guilds/$id/channels'),
      _dataStore.client.get('/guilds/$id/members')
    ]);

    server.body['channels'] = channels.body;
    server.body['members'] = members.body;

    return _dataStore.marshaller.serializers.server.serialize(server.body);
  }
}
