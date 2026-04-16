import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/api/private/user.dart';

final class UserPart implements UserPartContract {
  final MarshallerContract _marshaller;
  final DataStoreContract _dataStore;

  UserPart(this._marshaller, this._dataStore);

  HttpClientStatus get status => _dataStore.client.status;

  @override
  Future<User?> get(Object id, bool force) async {
    final String key = _marshaller.cacheKey.user(id);

    final cachedUser = await _marshaller.cache?.get(key);
    if (!force && cachedUser != null) {
      final user = await _marshaller.serializers.user.serialize(cachedUser);

      return user;
    }

    final request = Request.json(endpoint: '/users/$id');
    final result = await _dataStore.requestBucket
        .query<Map<String, dynamic>>(request)
        .run(_dataStore.client.get);

    final raw = await _marshaller.serializers.user.normalize(result);
    final user = await _marshaller.serializers.user.serialize(raw);

    return user;
  }
}
