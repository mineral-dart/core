import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/message.dart';
import 'package:mineral/api/common/message_properties.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';

final class ServerMessage extends Message<ServerChannel> {
  final MessageProperties<ServerChannel> _properties;

  @override
  Snowflake get id => _properties.id;

  @override
  String get content => _properties.content;

  @override
  bool get isPinned => _properties.isPinned;

  List<MessageEmbed> get embeds => _properties.embeds;

  @override
  Snowflake get channelId => _properties.channelId;

  @override
  late final ServerChannel channel;

  DateTime get createdAt => _properties.createdAt;

  DateTime? get updatedAt => _properties.updatedAt;

  final Member author;

  ServerMessage(
    this._properties, {
    required this.author,
  });

  static Future<ServerMessage> copyWith(
    ServerMessage message, {
    bool? isPinned,
  }) async {
    final marshaller = ioc.resolve<MarshallerContract>();
    final deserializedMessage = await marshaller.serializers.message.deserialize(message);

    return marshaller.serializers.message
            .serialize({...deserializedMessage, 'pinned': isPinned ?? message.isPinned})
        as Future<ServerMessage>;
  }
}
