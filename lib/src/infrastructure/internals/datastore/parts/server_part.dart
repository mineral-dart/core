import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/http/discord_header.dart';

final class ServerPart implements ServerPartContract {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  @override
  Future<Server> get(Object id, bool force) async {
    final completer = Completer<Server>();
    final String key = _marshaller.cacheKey.server(id);

    final cachedServer = await _marshaller.cache?.get(key);
    if (!force && cachedServer != null) {
      final server = await _marshaller.serializers.server.serialize(
        cachedServer,
      );

      completer.complete(server);
      return completer.future;
    }

    final req = Request.json(endpoint: '/guilds/$id');
    final result = await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.get);

    final raw = await _marshaller.serializers.server.normalize(result);
    final server = await _marshaller.serializers.server.serialize(raw);

    completer.complete(server);
    return completer.future;
  }

  @override
  Future<Server> update(
    Object id,
    Map<String, dynamic> payload,
    String? reason,
  ) async {
    final req = Request.json(
      endpoint: '/guilds/$id',
      body: payload,
      headers: {DiscordHeader.auditLogReason(reason)},
    );

    final response = await _dataStore.client.patch(req);

    final rawServer = await _marshaller.serializers.server.normalize(
      response.body,
    );
    return _marshaller.serializers.server.serialize(rawServer);
  }

  @override
  Future<void> delete(Object id, String? reason) async {
    final req = Request.json(
      endpoint: '/guilds/$id',
      headers: {DiscordHeader.auditLogReason(reason)},
    );

    await _dataStore.client.delete(req);
  }
}
