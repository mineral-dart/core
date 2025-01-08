import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/server/managers/threads_manager.dart';

final class Server {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  final Snowflake id;
  final String? applicationId;
  final String name;
  final String? description;
  final Snowflake ownerId;
  final MemberManager members;
  final ServerSettings settings;
  final RoleManager roles;
  final ChannelManager channels;
  final ThreadsManager threads;
  final ServerAsset assets;

  Server({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.members,
    required this.settings,
    required this.roles,
    required this.channels,
    required this.description,
    required this.applicationId,
    required this.assets,
    required this.threads,
  });

  /// Set the server's name.
  ///
  /// ```dart
  /// await server.setName('New Server Name', reason: 'Testing');
  /// ```
  Future<void> setName(String name, {String? reason}) async {
    await _datastore.server.update(id.value, {'name': name}, reason);
  }

  /// Set the server's description.
  ///
  /// ```dart
  /// await server.setDescription('New Server Description', reason: 'Testing');
  /// ```
  Future<void> setDescription(String description, {String? reason}) async {
    await _datastore.server.update(id.value, {'description': description}, reason);
  }

  /// Set the default message notifications for the server.
  ///
  /// ```dart
  /// await server.setDefaultMessageNotifications(DefaultMessageNotification.allMessages, reason: 'Testing');
  /// ```
  Future<void> setDefaultMessageNotifications(DefaultMessageNotification value,
      {String? reason}) async {
    await _datastore.server
        .update(id.value, {'default_message_notifications': value.value}, reason);
  }

  /// Set the explicit content filter for the server.
  ///
  /// ```dart
  /// await server.setExplicitContentFilter(ExplicitContentFilter.disabled, reason: 'Testing');
  /// ```
  Future<void> setExplicitContentFilter(ExplicitContentFilter value, {String? reason}) async {
    await _datastore.server.update(id.value, {'explicit_content_filter': value.value}, reason);
  }

  /// Set the server's afk timeout.
  ///
  ///  ```dart
  ///  await server.setAfkTimeout(300, reason: 'Testing');
  ///  ```
  Future<void> setAfkTimeout(int value, {String? reason}) async {
    await _datastore.server.update(id.value, {'afk_timeout': value}, reason);
  }

  /// Set the server's enabled premium features.
  ///
  /// ```dart
  /// await server.enablePremiumProgressBar(true, reason: 'Testing');
  /// ```
  Future<void> enablePremiumProgressBar(bool value, {String? reason}) async {
    await _datastore.server.update(id.value, {'premium_progress_bar_enabled': value}, reason);
  }

  /// Set the server's safety alerts channel.
  ///
  /// ```dart
  /// await server.setSafetyAlertsChannel('1091121140090535956', reason: 'Testing');
  /// ```
  Future<void> setSafetyAlertsChannel(String? channelId, {String? reason}) async {
    await _datastore.server.update(id.value, {'safety_alerts_channel_id': channelId}, reason);
  }

  /// Set the server's preferred locale.
  ///
  /// ```dart
  /// await server.setPreferredLocale('en-US', reason: 'Testing');
  /// ```
  Future<void> setPreferredLocale(String value, {String? reason}) async {
    await _datastore.server.update(id.value, {'preferred_locale': value}, reason);
  }

  /// Set the server's vanity url code.
  ///
  /// ```dart
  /// await server.setVanityUrlCode('new-vanity-url', reason: 'Testing');
  /// ```
  Future<void> setVanityUrlCode(String value, {String? reason}) async {
    await _datastore.server.update(id.value, {'vanity_url_code': value}, reason);
  }

  /// Resolve the server owner's name.
  /// ```dart
  /// final owner = await server.resolveOwner();
  /// ```
  Future<Member> resolveOwner({bool force = false}) async {
    final member = await _datastore.member.get(id.value, ownerId.value, force);
    return member!;
  }
}
