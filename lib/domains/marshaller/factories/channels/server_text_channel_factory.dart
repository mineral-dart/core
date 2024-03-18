import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_category_channel.dart';
import 'package:mineral/api/server/channels/server_text_channel.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/channel_factory.dart';
import 'package:mineral/domains/shared/helper.dart';

final class ServerTextChannelFactory implements ChannelFactoryContract<ServerTextChannel> {
  @override
  ChannelType get type => ChannelType.guildText;

  @override
  Future<ServerTextChannel> make(
      MarshallerContract marshaller, String guildId, Map<String, dynamic> json) async {
    final permissionOverwrites = await Future.wait(
      List.from(json['permission_overwrites'])
          .map((json) async => marshaller.serializers.channelPermissionOverwrite.serialize(json))
          .toList(),
    );

    final rawCategoryChannel = await marshaller.cache.get(json['parent_id']);

    return ServerTextChannel(
        id: Snowflake(json['id']),
        name: json['name'],
        position: json['position'],
        description: json['topic'],
        category: await Helper.createOrNullAsync(
            field: json['parent_id'],
            fn: () async => await marshaller.serializers.channels.serialize(rawCategoryChannel)
                as ServerCategoryChannel?),
        permissionOverwrites: permissionOverwrites);
  }

  @override
  Future<Map<String, dynamic>> deserialize(
      MarshallerContract marshaller, ServerTextChannel channel) async {
    return {
      'id': channel.id.value,
      'type': channel.type.value,
    };
  }
}
