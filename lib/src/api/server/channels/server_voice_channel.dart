import 'package:mineral/api.dart';
import 'package:mineral/src/api/common/managers/message_manager.dart';
import 'package:mineral/src/api/server/managers/threads_manager.dart';

final class ServerVoiceChannel extends ServerChannel {
  final ChannelProperties _properties;
  late final ChannelMethods _methods;

  late final MessageManager<ServerMessage> messages;

  @override
  Snowflake get id => _properties.id;

  @override
  ChannelType get type => _properties.type;

  @override
  String get name => _properties.name!;

  @override
  DateTime get createdAt => id.createdAt;

  int get position => _properties.position!;

  ThreadsManager get threads => _properties.threads;

  List<ChannelPermissionOverwrite> get permissions => _properties.permissions!;

  @override
  Snowflake get serverId => _properties.serverId!;

  Snowflake? get categoryId => _properties.categoryId;

  late final ServerCategoryChannel? category;

  late final List<VoiceState> members;

  ServerVoiceChannel(this._properties) {
    _methods = ChannelMethods(_properties.serverId!, _properties.id);
    messages = MessageManager(_properties.id);
  }

  /// Sets the name of the channel.
  ///
  /// ```dart
  /// await channel.setName('new-name');
  /// ```
  Future<void> setName(String name, {String? reason}) =>
      _methods.setName(name, reason);

  /// Sets the category of the channel.
  ///
  /// ```dart
  /// await channel.setCategory('new-category-id');
  /// ```
  Future<void> setCategory(String categoryId, {String? reason}) =>
      _methods.setCategory(categoryId, reason);

  /// Sets the position of the channel.
  ///
  /// ```dart
  /// await channel.setPosition(1);
  /// ```
  Future<void> setPosition(int position, {String? reason}) =>
      _methods.setPosition(position, reason);

  /// Sets the NSFW status of the channel.
  ///
  /// ```dart
  /// await channel.setNsfw(true);
  /// ```
  Future<void> setNsfw(bool value, {String? reason}) =>
      _methods.setNsfw(value, reason);

  /// Sets the rate limit per user for the channel.
  ///
  /// ```dart
  /// await channel.setRateLimitPerUser(10);
  /// ```
  Future<void> setRateLimitPerUser(Duration value, {String? reason}) =>
      _methods.setRateLimitPerUser(value, reason);

  /// Sets the bitrate of the voice channel.
  ///
  /// ```dart
  /// await channel.setBitrate(64000);
  /// ```
  Future<void> setBitrate(int bitrate, {String? reason}) =>
      _methods.setBitrate(bitrate, reason);

  /// Sets the user limit of the voice channel.
  ///
  /// ```dart
  /// await channel.setUserLimit(10);
  /// ```
  Future<void> setUserLimit(int userLimit, {String? reason}) =>
      _methods.setUserLimit(userLimit, reason);

  /// Sets the RTC region of the voice channel.
  ///
  /// ```dart
  /// await channel.setRtcRegion('us-west');
  /// ```
  Future<void> setRtcRegion(String rtcRegion, {String? reason}) =>
      _methods.setRtcRegion(rtcRegion, reason);

  /// Sets the video quality of the voice channel.
  ///
  /// ```dart
  /// await channel.setVideoQuality(VideoQuality.high);
  /// ```
  Future<void> setVideoQuality(VideoQuality quality, {String? reason}) =>
      _methods.setVideoQuality(quality, reason);

  /// Deletes the channel.
  ///
  /// ```dart
  /// await channel.delete();
  /// ```
  Future<void> delete({String? reason}) => _methods.delete(reason);
}
