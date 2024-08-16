import 'dart:async';

import 'package:collection/collection.dart';
import 'package:mineral/api/common/channel.dart';
import 'package:mineral/infrastructure/internals/marshaller/factories/channels/private_channel_factory.dart';
import 'package:mineral/infrastructure/internals/marshaller/factories/channels/server_announcement_channel_factory.dart';
import 'package:mineral/infrastructure/internals/marshaller/factories/channels/server_category_channel_factory.dart';
import 'package:mineral/infrastructure/internals/marshaller/factories/channels/server_forum_channel_factory.dart';
import 'package:mineral/infrastructure/internals/marshaller/factories/channels/server_stage_channel_factory.dart';
import 'package:mineral/infrastructure/internals/marshaller/factories/channels/server_text_channel_factory.dart';
import 'package:mineral/infrastructure/internals/marshaller/factories/channels/server_voice_channel_factory.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/channel_factory.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';

final class ChannelSerializer<T extends Channel?> implements SerializerContract<T> {
  final MarshallerContract _marshaller;

  final List<ChannelFactoryContract> _factories = [
    ServerTextChannelFactory(),
    ServerVoiceChannelFactory(),
    ServerCategoryChannelFactory(),
    ServerAnnouncementChannelFactory(),
    ServerForumChannelFactory(),
    ServerStageChannelFactory(),
    PrivateChannelFactory(),
  ];

  ChannelSerializer(this._marshaller);

  @override
  Future<T> normalize(Map<String, dynamic> json) async {
    final channelFactory = _factories.firstWhereOrNull((element) => element.type.value == json['type']);
    if (channelFactory == null) {
      _marshaller.logger.warn('Channel type not found ${json['type']}');
      return null as T;
    }

    return channelFactory.normalize(_marshaller, json) as Future<T>;
  }

  @override
  Future<T> serialize(Map<String, dynamic> json) {
    final channelFactory = _factories.firstWhereOrNull((element) => element.type.value == json['type']);

    if (channelFactory == null) {
      _marshaller.logger.warn('Channel type not found ${json['type']}');
      throw Exception('Channel type not found ${json['type']}');
    }

    return channelFactory.serialize(_marshaller, json) as Future<T>;
  }

  @override
  Future<Map<String, dynamic>> deserialize(Channel? channel) async {
    final channelFactory = _factories.firstWhereOrNull((element) => element.type == channel?.type);
    if (channelFactory != null) {
      return channelFactory.deserialize(_marshaller, channel!);
    }

    throw Exception('Channel type not found ${channel?.type}');
  }
}
