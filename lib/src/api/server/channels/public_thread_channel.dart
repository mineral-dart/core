import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/managers/message_manager.dart';
import 'package:mineral/src/api/server/threads/thread_metadata.dart';

class PublicThreadChannel extends ServerChannel implements ThreadChannel {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

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
  Snowflake get serverId => _properties.serverId!;

  @override
  DateTime get createdAt => id.createdAt;

  final ThreadMetadata metadata;

  int get rateLimitPerUser => _properties.rateLimitPerUser!;

  Snowflake? get lastMessageId => _properties.lastMessageId;

  int get bitrate => _properties.bitrate!;

  int get userLimit => _properties.userLimit!;

  String? get rtcRegion => _properties.rtcRegion;

  Snowflake get ownerId => Snowflake.parse(_properties.ownerId!);

  DateTime? get lastPinTimestamp => _properties.lastPinTimestamp != null
      ? DateTime.tryParse(_properties.lastPinTimestamp!)
      : null;

  int get messageCount => _properties.messageCount!;

  int get flags => _properties.flags!;

  int get memberCount => _properties.memberCount!;

  int get totalMessageSent => _properties.totalMessageSent!;

  Snowflake? get parentId => _properties.categoryId;

  PublicThreadChannel(this._properties, this.metadata) {
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

  /// Sets the description of the channel.
  ///
  /// ```dart
  /// await channel.setDescription('new-description');
  /// ```
  Future<void> setDescription(String description, {String? reason}) =>
      _methods.setDescription(description, reason);

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

  /// Sets the default auto-archive duration for the channel.
  ///
  /// ```dart
  /// await channel.setDefaultAutoArchiveDuration(60);
  /// ```
  Future<void> setDefaultAutoArchiveDuration(Duration value,
          {String? reason}) =>
      _methods.setDefaultAutoArchiveDuration(value, reason);

  /// Sets the default thread rate limit per user for the channel.
  ///
  /// ```dart
  /// await channel.setDefaultThreadRateLimitPerUser(10);
  /// ```
  Future<void> setDefaultThreadRateLimitPerUser(Duration value,
          {String? reason}) =>
      _methods.setDefaultThreadRateLimitPerUser(value, reason);

  /// Resolves the [User] object of the owner of the channel.
  /// ```dart
  /// final owner = await channel.resolveOwner();
  /// ```
  Future<User> resolveOwner() async {
    final user = await _datastore.user.get(ownerId.value, false);
    return user!;
  }

  /// Sends a message to the channel.
  ///
  /// ```dart
  /// await channel.send(content: 'Hello, world!');
  /// ```
  Future<void> send(MessageBuilder builder) =>
      _methods.send(serverId: serverId, builder: builder);

  /// Deletes the channel.
  ///
  /// ```dart
  /// await channel.delete();
  /// ```
  Future<void> delete({String? reason}) => _methods.delete(reason);
}
