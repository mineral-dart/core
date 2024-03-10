import 'package:mineral/api/server/server_settings.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/serializer.dart';

final class ServerSettingsSerializer implements SerializerContract<ServerSettings> {
  final MarshallerContract _marshaller;

  ServerSettingsSerializer(this._marshaller);

  @override
  Future<ServerSettings> serialize(Map<String, dynamic> json) => ServerSettings.fromJson(_marshaller, json);

  @override
  Map<String, dynamic> deserialize(ServerSettings object) {
    throw UnimplementedError();
  }
}
