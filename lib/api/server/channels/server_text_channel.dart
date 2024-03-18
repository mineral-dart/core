import 'package:mineral/api/common/channel_permission_overwrite.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';
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
    required List<ChannelPermissionOverwrite> permissionOverwrites,
    required this.description,
    required this.category,
  }) : super(id, ChannelType.guildText, name, position, permissionOverwrites);
}
