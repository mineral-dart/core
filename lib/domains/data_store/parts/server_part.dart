import 'dart:async';

import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/data_store/data_store.dart';
import 'package:mineral/domains/data_store/data_store_part.dart';

final class ServerPart implements DataStorePart {
  final DataStore _dataStore;

  ServerPart(this._dataStore);

  Future<Server> getServer(String id) async {
    final cachedRawServer = await _dataStore.marshaller.cache.get(id);
    if (cachedRawServer != null) {
      return _dataStore.marshaller.serializers.server.serialize(cachedRawServer);
    }

    final [serverResponse, channelsResponse, membersResponse] = await Future.wait([
      _dataStore.client.get('/guilds/$id'),
      _dataStore.client.get('/guilds/$id/channels'),
      _dataStore.client.get('/guilds/$id/members')
    ]);

    serverResponse.body['channels'] = channelsResponse.body;
    serverResponse.body['members'] = membersResponse.body;

    final server = await _dataStore.marshaller.serializers.server.serialize(serverResponse.body);
    await _dataStore.marshaller.cache.put(id, serverResponse.body);

    await Future.wait([
      ...server.channels.list.values.map((channel) => _dataStore.marshaller.cache.put(channel.id, channel)),
      ...server.members.list.values.map((member) => _dataStore.marshaller.cache.put(member.id, member))
    ]);

    return server;
  }
}
