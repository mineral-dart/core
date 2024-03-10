import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/serializer.dart';

final class ServerMessageSerializer implements SerializerContract<ServerMessage> {
  final MarshallerContract _marshaller;

  ServerMessageSerializer(this._marshaller);

  @override
  Future<ServerMessage> serialize(Map<String, dynamic> json) async {
    final rawServer = await _marshaller.cache.get(json['guild_id']);
    if (rawServer == null) {
      throw 'Server not found';
    }

    final server = await _marshaller.serializers.server.serialize(rawServer);

    return ServerMessage.fromJson(
      server: server,
      json: json,
    );
  }

  @override
  Map<String, dynamic> deserialize(ServerMessage object) {
    throw UnimplementedError();
  }
}
