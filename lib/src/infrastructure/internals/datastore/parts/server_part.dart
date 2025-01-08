import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/http/discord_header.dart';
import 'package:mineral/src/infrastructure/services/http/http_request_option.dart';

final class ServerPart implements ServerPartContract {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  @override
  Future<Server> get(String id, bool force) async {
    final completer = Completer<Server>();
    final String key = _marshaller.cacheKey.server(id);

    final cachedServer = await _marshaller.cache?.get(key);
    if (!force && cachedServer != null) {
      final server = await _marshaller.serializers.server.serialize(cachedServer);

      completer.complete(server);
      return completer.future;
    }

    final result = await _dataStore.requestBucket
        .run<Map<String, dynamic>>(() => _dataStore.client.get('/guilds/$id'));

    final raw = await _marshaller.serializers.server.normalize(result);
    final server = await _marshaller.serializers.server.serialize(raw);

    completer.complete(server);
    return completer.future;
  }

  @override
  Future<Server> update(String id, Map<String, dynamic> payload, String? reason) async {
    final response = await _dataStore.client.patch('/guilds/$id',
        body: payload,
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    final rawServer = await _marshaller.serializers.server.normalize(response.body);
    return _marshaller.serializers.server.serialize(rawServer);
  }

  @override
  Future<void> delete(String id, String? reason) async {
    await _dataStore.client.delete('/guilds/$id',
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));
  }
}
