import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/infrastructure/internals/http/discord_header.dart';

final class ServerPart implements ServerPartContract {
  final MarshallerContract _marshaller;
  final DataStoreContract _dataStore;

  ServerPart(this._marshaller, this._dataStore);

  HttpClientStatus get status => _dataStore.client.status;

  @override
  Future<Server> get(Object id, bool force) async {
    final String key = _marshaller.cacheKey.server(id);

    final cachedServer = await _marshaller.cache?.get(key);
    if (!force && cachedServer != null) {
      final server =
          await _marshaller.serializers.server.serialize(cachedServer);

      return server;
    }

    final req = Request.json(endpoint: '/guilds/$id');
    final result = await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.get);

    final raw = await _marshaller.serializers.server.normalize(result);
    final server = await _marshaller.serializers.server.serialize(raw);

    return server;
  }

  @override
  Future<Server> update(
      Object id, Map<String, dynamic> payload, String? reason) async {
    final req = Request.json(
        endpoint: '/guilds/$id',
        body: payload,
        headers: {DiscordHeader.auditLogReason(reason)});

    final response = await _dataStore.client.patch(req);

    final rawServer = await _marshaller.serializers.server
        .normalize(response.body as Map<String, dynamic>);
    return _marshaller.serializers.server.serialize(rawServer);
  }

  @override
  Future<void> delete(Object id, String? reason) async {
    final req = Request.json(
        endpoint: '/guilds/$id',
        headers: {DiscordHeader.auditLogReason(reason)});

    await _dataStore.client.delete(req);
  }
}
