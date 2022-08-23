import 'package:mineral/api.dart';

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
}

enum VideoQualityMode {
  auto(1),
  full(2);

  final int value;
  const VideoQualityMode(this.value);
}
