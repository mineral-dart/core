import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/message_properties.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/serializer.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/domains/shared/helper.dart';

final class ServerMessageSerializer implements SerializerContract<ServerMessage> {
  final MarshallerContract _marshaller;

  ServerMessageSerializer(this._marshaller);

  @override
  Future<ServerMessage> serialize(Map<String, dynamic> json) async {
    final rawServer = await _marshaller.cache.get(json['guild_id']);
    if (rawServer == null) {
      throw 'Server not found';
    }

    final rawChannel = await _marshaller.cache.get(json['channel_id']);
    final channel = await _marshaller.serializers.channels.serialize(rawChannel);

    final messageProperties = MessageProperties.fromJson(channel as ServerChannel, json);

    final server = await _marshaller.serializers.server.serialize(rawServer);

    return ServerMessage(messageProperties,
        userId: json['author']['id'], author: server.members.getOrFail(json['author']['id']));
  }

  @override
  Map<String, dynamic> deserialize(ServerMessage object) {
    throw UnimplementedError();
  }
}
