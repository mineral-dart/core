import 'package:mineral/api.dart';
import 'package:mineral/src/api/builders/channel_builder.dart';
import 'package:mineral/src/api/managers/message_manager.dart';
import 'package:mineral/src/api/managers/permission_overwrite_manager.dart';
import 'package:mineral/src/api/managers/thread_manager.dart';
import 'package:mineral/src/api/managers/webhook_manager.dart';

class TextChannel extends TextBasedChannel {
  final String? _description;
  final String? _lastPinTime;
  final int _rateLimit;
  final ThreadManager _threads;

  TextChannel(
    this._description,
    this._lastPinTime,
    this._rateLimit,
    this._threads,
    super.nsfw,
    super.webhooks,
    super.messages,
    super.lastMessageId,
    super.guildId,
    super.parentId,
    super.label,
    super.type,
    super.position,
    super.flags,
    super.permissions,
    super.id
  );

  /// Get description of this
  String? get description => _description;

  /// Get last pinned [DateTime]
  DateTime? get lastPinTime => _lastPinTime != null ? DateTime.parse(_lastPinTime!) : null;

  /// Get rate limit
  int get rateLimit => _rateLimit;

  /// Access to [ThreadManager]
  ThreadManager get threads => _threads;

  /// Define the description if this
  /// ```dart
  /// final TextChannel channel = guild.channels.cache.getOrFail('240561194958716924');
  /// await channel.setDescription('Lorem ipsum dolor sit amet.');
  /// ```
  Future<void> setDescription (String value) async {
    await update(ChannelBuilder({ 'topic': value }));
  }

  /// Define the rate limit of this
  /// ```dart
  /// final TextChannel channel = guild.channels.cache.getOrFail('240561194958716924');
  /// await channel.setRateLimit(5000); // Rate limit for 5 seconds
  /// ```
  Future<void> setRateLimit (int limit) async {
    await update(ChannelBuilder({ 'rate_limit': limit }));
  }

  @override
  CategoryChannel? get parent => super.parent as CategoryChannel?;

  factory TextChannel.fromPayload(dynamic payload) {
    final permissionOverwriteManager = PermissionOverwriteManager();
    for (dynamic element in payload['permission_overwrites']) {
      final PermissionOverwrite overwrite = PermissionOverwrite.from(payload: element);
      permissionOverwriteManager.cache.putIfAbsent(overwrite.id, () => overwrite);
    }

    return TextChannel(
      payload['topic'],
      payload['last_pin_timestamp'],
      payload['rate_limit_per_user'],
      ThreadManager(payload['guild_id']),
      payload['nsfw'] ?? false,
      WebhookManager(payload['guild_id'], payload['id']),
      MessageManager(),
      payload['last_message_id'],
      payload['guild_id'],
      payload['parent_id'],
      payload['name'],
      payload['type'],
      payload['position'],
      payload['flags'],
      permissionOverwriteManager,
      payload['id']
    );
  }
}
