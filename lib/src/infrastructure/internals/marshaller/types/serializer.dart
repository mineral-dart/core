import 'dart:async';

abstract interface class SerializerContract<T> {
  FutureOr<Map<String, dynamic>> normalize(Map<String, dynamic> json);
  FutureOr<T> serialize(Map<String, dynamic> json);
  FutureOr<Map<String, dynamic>> deserialize(T object);
}
