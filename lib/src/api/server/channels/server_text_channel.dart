import 'package:mineral/api.dart';
import 'package:mineral/src/api/common/managers/message_manager.dart';
import 'package:mineral/src/api/server/managers/threads_manager.dart';

final class ServerTextChannel extends ServerChannel {
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

  List<ChannelPermissionOverwrite> get permissions => _properties.permissions!;

  String? get description => _properties.description;

  @override
  Snowflake get serverId => _properties.serverId!;

  Snowflake? get categoryId => _properties.categoryId;

  ThreadsManager get threads => _properties.threads;

  late final ServerCategoryChannel? category;

  ServerTextChannel(this._properties) {
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

  /// Sends a message with components to the channel.
  ///
  /// ```dart
  /// final buttons = [
  ///   MessageButton.primary('primary', label: 'label'),
  ///   MessageButton.secondary('secondary', label: 'label'),
  ///   MessageButton.danger('danger', label: 'label'),
  ///   MessageButton.link('https://google.com', label: 'label'),
  /// ];
  ///
  /// final channelSelectMenu = MessageMenu.channel('channel',
  ///   channelTypes: [ChannelType.guildText],
  ///   defaultValues: [Snowflake.parse('1322554770057068636')]);
  ///
  /// final builder = MessageComponentBuilder()
  ///   ..text('# Hello from World')
  ///   ..separator()
  ///   ..text('Hello from ${message.channelId}')
  ///   ..file(Attachment.path('assets/logo.png'))
  ///   ..file(await Attachment.network('https://i.redd.it/d2hd73xxwvaa1.jpg'));
  ///
  /// final message = await channel.send(builder);
  /// ```
  Future<T> send<T extends Message>(MessageBuilder builder) =>
      _methods.send(serverId: _properties.serverId, builder: builder);

  Future<T> sendPoll<T extends Message>(Poll poll) =>
      _methods.sendPoll<T>(poll);

  /// Deletes the channel.
  ///
  /// ```dart
  /// await channel.delete();
  /// ```
  Future<void> delete({String? reason}) => _methods.delete(reason);
}
