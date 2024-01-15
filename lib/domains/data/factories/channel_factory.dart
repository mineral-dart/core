import 'package:collection/collection.dart';
import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/domains/data/factories/channels/server_announcement_channel_factory.dart';
import 'package:mineral/domains/data/factories/channels/server_category_channel_factory.dart';
import 'package:mineral/domains/data/factories/channels/server_forum_channel_factory.dart';
import 'package:mineral/domains/data/factories/channels/server_text_channel_factory.dart';
import 'package:mineral/domains/data/factories/channels/server_voice_channel_factory.dart';
import 'package:mineral/domains/data/memory/memory_storage.dart';

abstract interface class ChannelFactoryContract<T extends Channel> {
  ChannelType get type;
  T make(MemoryStorageContract storage, String guildId, Map<String, dynamic> json);
}

final class ChannelFactory {
  static final List<ChannelFactoryContract> _factories = [
    ServerTextChannelFactory(),
    ServerVoiceChannelFactory(),
    ServerCategoryChannelFactory(),
    ServerAnnouncementChannelFactory(),
    ServerForumChannelFactory()
  ];

  static T? make<T extends Channel>(MemoryStorageContract storage, String guildId, Map<String, dynamic> json) {
    final channelFactory = _factories.firstWhereOrNull((element) => element.type.value == json['type']);

    if (channelFactory == null) {
      print('Channel type not found ${json['type']}');
      return null;
    }

    return channelFactory.make(storage, guildId, json) as T?;
  }
}
