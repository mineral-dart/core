import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/serializer.dart';

final class ServerSerializer<T extends Server> implements SerializerContract<Server> {
  final MarshallerContract _marshaller;

  ServerSerializer(this._marshaller);

  @override
  Server serialize(Map<String, dynamic> json) => Server.fromJson(_marshaller, json);

  @override
  Map<String, dynamic> deserialize(Server object) {
    throw UnimplementedError();
  }
}
