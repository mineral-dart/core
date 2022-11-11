import 'package:mineral/api.dart';
import 'package:mineral/src/api/builders/channel_builder.dart';
import 'package:mineral/src/api/managers/message_manager.dart';
import 'package:mineral/src/api/managers/permission_overwrite_manager.dart';
import 'package:mineral/src/api/managers/webhook_manager.dart';

class VoiceChannel extends TextBasedChannel {
  final int? _bitrate;
  final int? _userLimit;
  final String? _rtcRegion;
  final int _videoQualityMode;

  VoiceChannel(
    this._bitrate,
    this._userLimit,
    this._rtcRegion,
    this._videoQualityMode,
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

  /// Get bitrate of this
  int? get bitrate => _bitrate;

  /// Get [User] max on this
  int? get userLimit => _userLimit;

  /// Get region of this
  String? get rtcRegion => _rtcRegion;

  /// Get video quality of this
  int get videoQualityMode => _videoQualityMode;

  /// Get current online members
  Map<Snowflake, GuildMember> get members => guild.members.cache.where((member) => member.voice.channel?.id == id);

  /// Define the bitrate of this
  Future<void> setBitrate (int bitrate) async {
    await update(ChannelBuilder({ 'bitrate': bitrate }));
  }

  /// Define the rate limit of this
  Future<void> setUserLimit (int value) async {
    await update(ChannelBuilder({ 'user_limit': value }));
  }

  /// Define the rtc region of this
  Future<void> setRegion (String region) async {
    await update(ChannelBuilder({ 'rtc_region': region }));
  }

  /// Define the rtc region of this
  Future<void> setVideoQuality (VideoQualityMode mode) async {
    await update(ChannelBuilder({ 'video_quality_mode': mode.value }));
  }

  @override
  CategoryChannel? get parent => super.parent as CategoryChannel?;

  factory VoiceChannel.fromPayload(dynamic payload) {
    final permissionOverwriteManager = PermissionOverwriteManager();
    for (dynamic element in payload['permission_overwrites']) {
      final PermissionOverwrite overwrite = PermissionOverwrite.from(payload: element);
      permissionOverwriteManager.cache.putIfAbsent(overwrite.id, () => overwrite);
    }

    return VoiceChannel(
      payload['bitrate'],
      payload['user_limit'],
      payload['rtc_region'],
      payload['video_quality_mode'] ?? VideoQualityMode.auto.value,
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

enum VideoQualityMode {
  auto(1),
  full(2);

  final int value;
  const VideoQualityMode(this.value);
}
