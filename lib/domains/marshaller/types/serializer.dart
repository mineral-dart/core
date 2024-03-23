import 'dart:async';

abstract interface class SerializerContract<T> {
  FutureOr<T> serialize(Map<String, dynamic> json, {bool cache = false});
  FutureOr<Map<String, dynamic>> deserialize(T object);
}
