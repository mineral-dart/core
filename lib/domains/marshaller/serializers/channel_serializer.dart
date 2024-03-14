import 'package:collection/collection.dart';
import 'package:mineral/api/common/channel.dart';
import 'package:mineral/domains/marshaller/factories/channels/private_channel_factory.dart';
import 'package:mineral/domains/marshaller/factories/channels/server_announcement_channel_factory.dart';
import 'package:mineral/domains/marshaller/factories/channels/server_category_channel_factory.dart';
import 'package:mineral/domains/marshaller/factories/channels/server_forum_channel_factory.dart';
import 'package:mineral/domains/marshaller/factories/channels/server_text_channel_factory.dart';
import 'package:mineral/domains/marshaller/factories/channels/server_voice_channel_factory.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/channel_factory.dart';
import 'package:mineral/domains/marshaller/types/serializer.dart';

final class ChannelSerializer<T extends Channel?> implements SerializerContract<T> {
  final MarshallerContract _marshaller;

  final List<ChannelFactoryContract> _factories = [
    ServerTextChannelFactory(),
    ServerVoiceChannelFactory(),
    ServerCategoryChannelFactory(),
    ServerAnnouncementChannelFactory(),
    ServerForumChannelFactory(),
    PrivateChannelFactory(),
  ];

  ChannelSerializer(this._marshaller);

  @override
  Future<T> serialize(Map<String, dynamic> json) async {
    final channelFactory = _factories.firstWhereOrNull((element) => element.type.value == json['type']);

    if (channelFactory == null) {
      _marshaller.logger.warn('Channel type not found ${json['type']}');
      return null as T;
    }

    return channelFactory.make(_marshaller, json['guild_id'] ?? json['id'], json) as Future<T>;
  }

  @override
  Map<String, dynamic> deserialize(Channel? channel) {
    final channelFactory = _factories.firstWhereOrNull((element) => element.type == channel?.type);
    if (channelFactory != null) {
      return channelFactory.deserialize(channel!);
    }

    throw Exception('Channel type not found ${channel?.type}');
  }
}
