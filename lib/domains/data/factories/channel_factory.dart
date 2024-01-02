import 'package:collection/collection.dart';
import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/domains/data/factories/channels/guild_announcement_channel_factory.dart';
import 'package:mineral/domains/data/factories/channels/guild_category_channel_factory.dart';
import 'package:mineral/domains/data/factories/channels/guild_forum_channel_factory.dart';
import 'package:mineral/domains/data/factories/channels/guild_text_channel_factory.dart';
import 'package:mineral/domains/data/factories/channels/guild_voice_channel_factory.dart';

abstract interface class ChannelFactoryContract<T extends Channel> {
  ChannelType get type;
  T make(String guildId, Map<String, dynamic> json);
}

final class ChannelFactory {
  static final List<ChannelFactoryContract> _factories = [
    GuildTextChannelFactory(),
    GuildVoiceChannelFactory(),
    GuildCategoryChannelFactory(),
    GuildAnnouncementChannelFactory(),
    GuildForumChannelFactory()
  ];

  static Channel? make(String guildId, Map<String, dynamic> json) {
    final channelFactory = _factories.firstWhereOrNull((element) => element.type.value == json['type']);

    if (channelFactory == null) {
      print('Channel type not found ${json['type']}');
      return null;
    }

    return channelFactory.make(guildId, json);
  }
}
