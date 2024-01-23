abstract interface class SerializerContract<T> {
  T serialize(Map<String, dynamic> json);
  Map<String, dynamic> deserialize(T object);
}
