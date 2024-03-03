import 'package:mineral/api/server/role.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/serializer.dart';

final class ServerRoleSerializer<T extends Role> implements SerializerContract<Role> {
  final MarshallerContract _marshaller;

  ServerRoleSerializer(this._marshaller);

  @override
  Role serialize(Map<String, dynamic> json) => Role.fromJson(json);

  @override
  Map<String, dynamic> deserialize(Role object) {
    throw UnimplementedError();
  }
}
