import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/channels/permission_overwrite.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class PermissionOverwriteManager implements CacheManager<PermissionOverwrite> {
  @override
  Map<Snowflake, PermissionOverwrite> cache = {};

  Snowflake? guildId;
  late Channel channel;

  PermissionOverwriteManager({required this.guildId});

  @override
  Future<Map<Snowflake, PermissionOverwrite>> sync() async {
    throw UnimplementedError();
  }
}
