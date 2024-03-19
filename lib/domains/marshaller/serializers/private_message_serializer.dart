import 'package:mineral/api/common/message_properties.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/serializer.dart';

final class PrivateMessageSerializer implements SerializerContract<PrivateMessage> {
  final MarshallerContract _marshaller;

  PrivateMessageSerializer(this._marshaller);

  @override
  Future<PrivateMessage> serialize(Map<String, dynamic> json) async {
    final channel = await _marshaller.dataStore.channel.getChannel(json['channel_id']);
    final messageProperties = MessageProperties.fromJson(channel as PrivateChannel, json);

    final user = await _marshaller.serializers.user.serialize(json['author']);

    return PrivateMessage(messageProperties, userId: json['author']['id'], user: user);
  }

  @override
  Map<String, dynamic> deserialize(PrivateMessage message) {
    throw UnimplementedError();
  }
}
