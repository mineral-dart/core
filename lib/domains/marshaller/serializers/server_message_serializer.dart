import 'package:mineral/api/common/embed/message_embed.dart';
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

    final server = await _marshaller.serializers.server.serialize(rawServer);

    return ServerMessage(
        id: Snowflake(json['id']),
        content: json['content'],
        createdAt: DateTime.parse(json['timestamp']),
        updatedAt: Helper.createOrNull(
            field: json['edited_timestamp'], fn: () => DateTime.parse(json['edited_timestamp'])),
        channel: server.channels.getOrFail(json['channel_id']),
        embeds: List<MessageEmbed>.from(json['embeds'].map(MessageEmbed.fromJson)),
        userId: json['author']['id'],
        author: server.members.getOrFail(json['author']['id']));
  }

  @override
  Map<String, dynamic> deserialize(ServerMessage object) {
    throw UnimplementedError();
  }
}
