import 'dart:async';

import 'package:collection/collection.dart';
import 'package:mineral/api.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/services/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/factories/channels/private_channel_factory.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/factories/channels/server_announcement_channel_factory.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/factories/channels/server_category_channel_factory.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/factories/channels/server_forum_channel_factory.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/factories/channels/server_public_thread_channel_factory.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/factories/channels/server_stage_channel_factory.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/factories/channels/server_text_channel_factory.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/factories/channels/server_voice_channel_factory.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/factories/channels/unknown_channel_factory.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/channel_factory.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';

final class ChannelSerializer<T extends Channel?>
    implements SerializerContract<T> {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  final List<ChannelFactoryContract> _factories = [
    ServerTextChannelFactory(),
    ServerVoiceChannelFactory(),
    ServerCategoryChannelFactory(),
    ServerAnnouncementChannelFactory(),
    ServerForumChannelFactory(),
    ServerStageChannelFactory(),
    PrivateChannelFactory(),
    ServerPublicThreadChannelFactory(),
    UnknownChannelFactory(),
  ];

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final channelFactory = _factories
        .firstWhereOrNull((element) => element.type.value == json['type']);
    if (channelFactory == null) {
      _marshaller.logger.warn('Channel type not found ${json['type']}');
      return json;
    }

    return channelFactory.normalize(_marshaller, json);
  }

  @override
  Future<T> serialize(Map<String, dynamic> json) {
    final channelFactory = _factories.firstWhere(
        (element) => element.type.value == json['type'],
        orElse: () => _factories
            .firstWhere((element) => element.type == ChannelType.unknown));

    if (channelFactory case UnknownChannelFactory()) {
      _marshaller.logger.warn('Channel type not found ${json['type']}');
    }

    return channelFactory.serialize(_marshaller, json) as Future<T>;
  }

  @override
  Future<Map<String, dynamic>> deserialize(Channel? channel) async {
    final channelFactory =
        _factories.firstWhereOrNull((element) => element.type == channel?.type);
    if (channelFactory != null) {
      return channelFactory.deserialize(_marshaller, channel!);
    }

    throw Exception('Channel type not found ${channel?.type}');
  }
}
