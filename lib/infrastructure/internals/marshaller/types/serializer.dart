import 'dart:async';

abstract interface class SerializerContract<T> {
  FutureOr<T> serializeRemote(Map<String, dynamic> json);
  FutureOr<T> serializeCache(Map<String, dynamic> json);
  FutureOr<Map<String, dynamic>> deserialize(T object);
}
