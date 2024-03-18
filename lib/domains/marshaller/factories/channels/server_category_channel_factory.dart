import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_category_channel.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/channel_factory.dart';

final class ServerCategoryChannelFactory implements ChannelFactoryContract<ServerCategoryChannel> {
  @override
  ChannelType get type => ChannelType.guildCategory;

  @override
  Future<ServerCategoryChannel> make(MarshallerContract marshaller, String guildId, Map<String, dynamic> json) async {
    final permissionOverwrites = await Future.wait(
      List.from(json['permission_overwrites'])
          .map((json) async => marshaller.serializers.channelPermissionOverwrite.serialize(json))
          .toList(),
    );

    return ServerCategoryChannel(
      id: Snowflake(json['id']),
      name: json['name'],
      position: json['position'],
      permissionOverwrites: permissionOverwrites
    );
  }

  @override
  Future<Map<String, dynamic>> deserialize(MarshallerContract marshaller, ServerCategoryChannel channel) async {
    return {
      'id': channel.id.value,
      'type': channel.type.value,
    };
  }
}
