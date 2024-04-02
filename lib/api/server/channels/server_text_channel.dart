import 'package:mineral/api/common/channel_methods.dart';
import 'package:mineral/api/common/channel_permission_overwrite.dart';
import 'package:mineral/api/common/channel_properties.dart';
import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_category_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';

final class ServerTextChannel extends ServerChannel {
  final ChannelProperties _properties;
  final ChannelMethods _methods;

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

  String? get description => _properties.description;

  late final ServerCategoryChannel? category;

  Snowflake get guildId => _properties.guildId!;

  ServerTextChannel(this._properties) : _methods = ChannelMethods(_properties.id);

  Future<void> setName(String name, {String? reason}) => _methods.setName(name, reason);

  Future<void> setDescription(String description, {String? reason}) =>
      _methods.setDescription(description, reason);

  Future<void> setCategory(String categoryId, {String? reason}) =>
      _methods.setCategory(categoryId, reason);

  Future<void> setPosition(int position, {String? reason}) =>
      _methods.setPosition(position, reason);

  Future<void> setNsfw(bool nsfw, {String? reason}) => _methods.setNsfw(nsfw, reason);

  Future<void> setRateLimitPerUser(int rateLimitPerUser, {String? reason}) =>
      _methods.setRateLimitPerUser(rateLimitPerUser, reason);

  Future<void> setDefaultAutoArchiveDuration(int defaultAutoArchiveDuration, {String? reason}) =>
      _methods.setDefaultAutoArchiveDuration(defaultAutoArchiveDuration, reason);

  Future<void> setDefaultThreadRateLimitPerUser(int value, {String? reason}) =>
      _methods.setDefaultThreadRateLimitPerUser(value, reason);

  Future<void> send({String? content, List<MessageEmbed>? embeds}) =>
      _methods.send(guildId: _properties.guildId, content: content, embeds: embeds);

  Future<void> delete({String? reason}) => _methods.delete(reason);
}
