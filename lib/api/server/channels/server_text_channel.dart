import 'package:mineral/api/common/channel_permission_overwrite.dart';
import 'package:mineral/api/common/channel_properties.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_category_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';

final class ServerTextChannel extends ServerChannel {
  final ChannelProperties _properties;

  @override
  Snowflake get id => _properties.id;

  @override
  ChannelType get type => _properties.type;

  @override
  String get name => _properties.name;

  @override
  int get position => _properties.position;

  @override
  List<ChannelPermissionOverwrite> get permissions => _properties.permissions!;

  String? get description => _properties.description;

  late final ServerCategoryChannel? category;

  ServerTextChannel(this._properties);

}
