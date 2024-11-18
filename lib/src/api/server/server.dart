import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/managers/threads_manager.dart';
import 'package:mineral/src/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/src/infrastructure/internals/datastore/parts/server_part.dart';

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

  /// Set the server's name.
  ///
  /// ```dart
  /// await server.setName('New Server Name', reason: 'Testing');
  /// ```
  Future<void> setName(String name, {String? reason}) async {
    await _serverPart.updateServer(id, {'name': name}, reason);
  }

  /// Set the server's description.
  ///
  /// ```dart
  /// await server.setDescription('New Server Description', reason: 'Testing');
  /// ```
  Future<void> setDescription(String description, {String? reason}) async {
    await _serverPart.updateServer(id, {'description': description}, reason);
  }

  /// Set the default message notifications for the server.
  ///
  /// ```dart
  /// await server.setDefaultMessageNotifications(DefaultMessageNotification.allMessages, reason: 'Testing');
  /// ```
  Future<void> setDefaultMessageNotifications(DefaultMessageNotification value,
      {String? reason}) async {
    await _serverPart.updateServer(
        id, {'default_message_notifications': value.value}, reason);
  }

  /// Set the explicit content filter for the server.
  ///
  /// ```dart
  /// await server.setExplicitContentFilter(ExplicitContentFilter.disabled, reason: 'Testing');
  /// ```
  Future<void> setExplicitContentFilter(ExplicitContentFilter value,
      {String? reason}) async {
    await _serverPart.updateServer(
        id, {'explicit_content_filter': value.value}, reason);
  }

  /// Set the server's afk timeout.
  ///
  ///  ```dart
  ///  await server.setAfkTimeout(300, reason: 'Testing');
  ///  ```
  Future<void> setAfkTimeout(int value, {String? reason}) async {
    await _serverPart.updateServer(id, {'afk_timeout': value}, reason);
  }

  /// Set the server's afk channel.
  ///
  /// ```dart
  /// await server.setAfkChannel('1091121140090535956', reason: 'Testing');
  /// ```
  Future<void> setAfkChannel(String? channelId, {String? reason}) async {
    await _serverPart.updateServer(id, {'afk_channel_id': channelId}, reason);
  }

  /// Set the server's system channel.
  ///
  /// ```dart
  /// await server.setSystemChannel('1091121140090535956', reason: 'Testing');
  /// ```
  Future<void> setSystemChannel(String? channelId, {String? reason}) async {
    await _serverPart.updateServer(
        id, {'system_channel_id': channelId}, reason);
  }

  /// Set the server's rules channel.
  ///
  /// ```dart
  /// await server.setRulesChannel('1091121140090535956', reason: 'Testing');
  /// ```
  Future<void> setRulesChannel(String? channelId, {String? reason}) async {
    await _serverPart.updateServer(id, {'rules_channel_id': channelId}, reason);
  }

  /// Set the server's public updates channel.
  ///
  /// ```dart
  /// await server.setPublicUpdatesChannel('1091121140090535956', reason: 'Testing');
  /// ```
  Future<void> setPublicUpdatesChannel(String? channelId,
      {String? reason}) async {
    await _serverPart.updateServer(
        id, {'public_updates_channel_id': channelId}, reason);
  }

  /// Set the server's enabled premium features.
  ///
  /// ```dart
  /// await server.enablePremiumProgressBar(true, reason: 'Testing');
  /// ```
  Future<void> enablePremiumProgressBar(bool value, {String? reason}) async {
    await _serverPart.updateServer(
        id, {'premium_progress_bar_enabled': value}, reason);
  }

  /// Set the server's safety alerts channel.
  ///
  /// ```dart
  /// await server.setSafetyAlertsChannel('1091121140090535956', reason: 'Testing');
  /// ```
  Future<void> setSafetyAlertsChannel(String? channelId,
      {String? reason}) async {
    await _serverPart.updateServer(
        id, {'safety_alerts_channel_id': channelId}, reason);
  }

  /// Set the server's preferred locale.
  ///
  /// ```dart
  /// await server.setPreferredLocale('en-US', reason: 'Testing');
  /// ```
  Future<void> setPreferredLocale(String value, {String? reason}) async {
    await _serverPart.updateServer(id, {'preferred_locale': value}, reason);
  }

  /// Set the server's vanity url code.
  ///
  /// ```dart
  /// await server.setVanityUrlCode('new-vanity-url', reason: 'Testing');
  /// ```
  Future<void> setVanityUrlCode(String value, {String? reason}) async {
    await _serverPart.updateServer(id, {'vanity_url_code': value}, reason);
  }
}
