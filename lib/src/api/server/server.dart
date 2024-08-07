import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/enums/default_message_notification.dart';
import 'package:mineral/api/server/enums/explicit_content_filter.dart';
import 'package:mineral/api/server/managers/channel_manager.dart';
import 'package:mineral/api/server/managers/member_manager.dart';
import 'package:mineral/api/server/managers/role_manager.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/server_assets.dart';
import 'package:mineral/api/server/server_settings.dart';
import 'package:mineral/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/infrastructure/internals/datastore/parts/server_part.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/managers/channel_manager.dart';
import 'package:mineral/src/api/server/managers/member_manager.dart';
import 'package:mineral/src/api/server/managers/role_manager.dart';
import 'package:mineral/src/api/server/managers/threads_manager.dart';
import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/api/server/server_assets.dart';
import 'package:mineral/src/api/server/server_settings.dart';

final class Server {
  ServerPart get _serverPart => ioc.resolve<DataStoreContract>().server;

  final Snowflake id;
  final String? applicationId;
  final String name;
  final String? description;
  final Member owner;
  final MemberManager members;
  final ServerSettings settings;
  final RoleManager roles;
  final ChannelManager channels;
  final ThreadsManager threads;
  final ServerAsset assets;

  Server({
    required this.id,
    required this.name,
    required this.members,
    required this.settings,
    required this.roles,
    required this.channels,
    required this.description,
    required this.applicationId,
    required this.assets,
    required this.owner,
    required this.threads,
  });

  Future<void> setName(String name, {String? reason}) async {
    await _serverPart.updateServer(id, {'name': name}, reason);
  }

  Future<void> setDescription(String description, {String? reason}) async {
    await _serverPart.updateServer(id, {'description': description}, reason);
  }

  Future<void> setDefaultMessageNotifications(DefaultMessageNotification value, {String? reason}) async {
    await _serverPart.updateServer(id, {'default_message_notifications': value.value}, reason);
  }

  Future<void> setExplicitContentFilter(ExplicitContentFilter value, {String? reason}) async {
    await _serverPart.updateServer(id, {'explicit_content_filter': value.value}, reason);
  }

  Future<void> setAfkTimeout(int value, {String? reason}) async {
    await _serverPart.updateServer(id, {'afk_timeout': value}, reason);
  }

  Future<void> setAfkChannel(String? channelId, {String? reason}) async {
    await _serverPart.updateServer(id, {'afk_channel_id': channelId}, reason);
  }

  Future<void> setSystemChannel(String? channelId, {String? reason}) async {
    await _serverPart.updateServer(id, {'system_channel_id': channelId}, reason);
  }

  Future<void> setRulesChannel(String? channelId, {String? reason}) async {
    await _serverPart.updateServer(id, {'rules_channel_id': channelId}, reason);
  }
}
