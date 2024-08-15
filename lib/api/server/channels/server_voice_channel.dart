import 'package:mineral/api/common/channel_methods.dart';
import 'package:mineral/api/common/channel_permission_overwrite.dart';
import 'package:mineral/api/common/channel_properties.dart';
import 'package:mineral/api/common/managers/message_manager.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/common/video_quality.dart';
import 'package:mineral/api/server/channels/server_category_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/server_message.dart';

final class ServerVoiceChannel extends ServerChannel {
  final ChannelProperties _properties;
  final ChannelMethods _methods;

  final MessageManager<ServerMessage> messages = MessageManager();

  @override
  Snowflake get id => _properties.id;

  @override
  ChannelType get type => _properties.type;

  @override
  String get name => _properties.name!;

  @override
  int get position => _properties.position!;

  @override
  List<ChannelPermissionOverwrite> get permissions => _properties.permissions!;

  @override
  Snowflake get guildId => _properties.guildId!;

  Snowflake? get categoryId => _properties.categoryId;

  late final ServerCategoryChannel? category;

  ServerVoiceChannel(this._properties) : _methods = ChannelMethods(_properties.id);

  Future<void> setName(String name, {String? reason}) => _methods.setName(name, reason);

  Future<void> setCategory(String categoryId, {String? reason}) =>
      _methods.setCategory(categoryId, reason);

  Future<void> setPosition(int position, {String? reason}) =>
      _methods.setPosition(position, reason);

  Future<void> setNsfw(bool nsfw, {String? reason}) => _methods.setNsfw(nsfw, reason);

  Future<void> setRateLimitPerUser(int rateLimitPerUser, {String? reason}) =>
      _methods.setRateLimitPerUser(rateLimitPerUser, reason);

  Future<void> setBitrate(int bitrate, {String? reason}) => _methods.setBitrate(bitrate, reason);

  Future<void> setUserLimit(int userLimit, {String? reason}) => _methods.setUserLimit(userLimit, reason);

  Future<void> setRtcRegion(String rtcRegion, {String? reason}) => _methods.setRtcRegion(rtcRegion, reason);

  Future<void> setVideoQuality(VideoQuality quality, {String? reason}) =>
      _methods.setVideoQuality(quality, reason);

  Future<void> delete({String? reason}) => _methods.delete(reason);
}
