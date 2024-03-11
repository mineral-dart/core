import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/channels/server_category_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/helper.dart';

final class ServerTextChannel extends ServerChannel {
  final String? description;

  final ServerCategoryChannel? category;

  ServerTextChannel({
    required Snowflake id,
    required String name,
    required int position,
    required this.description,
    required this.category,
  }) : super(id, name, position);

  static Future<ServerTextChannel> fromJson(
      MarshallerContract marshaller, String guildId, Map<String, dynamic> json) async {
    final rawCategoryChannel = await marshaller.cache.get(json['parent_id']);

    return ServerTextChannel(
        id: Snowflake(json['id']),
        name: json['name'],
        position: json['position'],
        description: json['topic'],
        category: await Helper.createOrNullAsync(
            field: json['parent_id'],
            fn: () async => await marshaller.serializers.channels.serialize(rawCategoryChannel)
                as ServerCategoryChannel?));
  }
}
