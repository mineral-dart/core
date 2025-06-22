import 'dart:async';

import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/api/private/user.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';

final class UserPart implements UserPartContract {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  @override
  Future<User?> get(Object id, bool force) async {
    final completer = Completer<User>();
    final String key = _marshaller.cacheKey.user(id);

    final cachedUser = await _marshaller.cache?.get(key);
    if (!force && cachedUser != null) {
      final user = await _marshaller.serializers.user.serialize(cachedUser);

      completer.complete(user);
      return completer.future;
    }

    final request = Request.json(endpoint: '/users/$id');
    final result = await _dataStore.requestBucket
        .run<Map<String, dynamic>>(() => _dataStore.client.get(request));

    final raw = await _marshaller.serializers.user.normalize(result);
    final user = await _marshaller.serializers.user.serialize(raw);

    completer.complete(user);
    return completer.future;
  }
}
