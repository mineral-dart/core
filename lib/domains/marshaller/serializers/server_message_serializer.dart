import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/message.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/serializer.dart';

final class ServerMessageSerializer implements SerializerContract<ServerMessage> {
  final MarshallerContract _marshaller;

  ServerMessageSerializer(this._marshaller);

  @override
  ServerMessage serialize(Map<String, dynamic> json) {
    final server = _marshaller.storage.servers[json['guild_id']];

    if (server == null) {
      throw 'Server not found';
    }

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
