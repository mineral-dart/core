import 'package:mineral/container.dart';
import 'package:mineral/src/api/common/channel.dart';
import 'package:mineral/src/api/common/message_properties.dart';
import 'package:mineral/src/api/private/channels/private_channel.dart';
import 'package:mineral/src/api/private/private_message.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/message_factory.dart';

final class PrivateMessageFactory implements MessageFactory<PrivateMessage> {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<PrivateMessage> serialize(Map<String, dynamic> json) async {
    final channel = json['channel'] as Channel;
    final messageProperties =
        MessageProperties.fromJson(channel as PrivateChannel, json);

    final user = await _marshaller.serializers.user.serialize(json['author']);

    return PrivateMessage(messageProperties,
        userId: json['author']['id'], author: user);
  }

  @override
  Map<String, dynamic> deserialize(PrivateMessage message) {
    return {
      'id': message.id,
      'content': message.content,
      'embeds': message.embeds
          .map(_marshaller.serializers.embed.deserialize)
          .toList(),
      'channel_id': message.channel.id,
      'created_at': message.createdAt.toIso8601String(),
      'updated_at': message.updatedAt?.toIso8601String(),
    };
  }
}
