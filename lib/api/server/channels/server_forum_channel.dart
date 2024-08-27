import 'package:mineral/api.dart';
import 'package:mineral/api/server/managers/threads_manager.dart';

final class ServerForumChannel extends ServerChannel {
  final ChannelProperties _properties;

  @override
  Snowflake get id => _properties.id;

  @override
  ChannelType get type => _properties.type;

  @override
  String get name => _properties.name!;

  @override
  int get position => _properties.position!;

  @override
  ThreadsManager get threads => _properties.threads;

  @override
  List<ChannelPermissionOverwrite> get permissions => _properties.permissions!;

  String? get description => _properties.description;

  Snowflake? get categoryId => _properties.categoryId;

  final SortOrderType? sortOrder;

  final ForumLayoutType? layoutType;

  late final ServerCategoryChannel? category;

  @override
  Snowflake get serverId => _properties.serverId!;

  @override
  late final Server server;

  ServerForumChannel(this._properties,
      {required this.sortOrder, required this.layoutType});
}
