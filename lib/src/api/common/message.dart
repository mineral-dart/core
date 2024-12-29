import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';

abstract interface class BaseMessage {
  Snowflake get id;

  String get content;

  List<MessageEmbed> get embeds;

  Snowflake get channelId;

  Snowflake? get authorId;

  DateTime get createdAt;

  DateTime? get updatedAt;

  Future<T> resolveChannel<T extends Channel>();

  Future<void> reply(
      {String? content, List<MessageEmbed>? embeds, List<MessageComponent>? components});

  Future<void> edit(
      String? content, List<MessageEmbed>? embeds, List<MessageComponent>? components);
}

abstract interface class ServerMessage implements BaseMessage {
  Future<Member> resolveMember({bool force = false});
}

abstract interface class PrivateMessage implements BaseMessage {
  Future<User> resolveUser({bool force = false});
}

final class Message implements ServerMessage, PrivateMessage, BaseMessage {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();
  final MessageProperties _properties;

  @override
  Snowflake get id => _properties.id;

  @override
  String get content => _properties.content;

  @override
  List<MessageEmbed> get embeds => _properties.embeds;

  @override
  Snowflake get channelId => _properties.channelId;

  @override
  Snowflake? get authorId => _properties.authorId;

  @override
  DateTime get createdAt => _properties.createdAt;

  @override
  DateTime? get updatedAt => _properties.updatedAt;

  Message(this._properties);

  @override
  Future<void> edit(
      String? content, List<MessageEmbed>? embeds, List<MessageComponent>? components) async {
    _datastore.message.update(
        id: id, channelId: channelId, content: content, embeds: embeds, components: components);
  }

  @override
  Future<Member> resolveMember({bool force = false}) async {
    final channel = await resolveChannel<ServerTextChannel>();
    final member = await _datastore.member.get(channel.serverId.value, authorId!.value, force);
    return member!;
  }

  @override
  Future<User> resolveUser({bool force = false}) async {
    final user = await _datastore.user.get(authorId!.value, force);
    return user!;
  }

  @override
  Future<T> resolveChannel<T extends Channel>() async {
    final channel = await _datastore.channel.get<T>(channelId.value, false);
    return channel!;
  }

  /// Reply to the original message.
  ///
  /// ```dart
  /// await message.reply(content: 'Replying to the message');
  /// ```
  @override
  Future<void> reply(
      {String? content, List<MessageEmbed>? embeds, List<MessageComponent>? components}) async {
    _datastore.message.reply(
        id: id,
        channelId: channelId,
        content: content,
        embeds: embeds,
        components: components);
  }

  /// Pin the message.
  ///
  /// ```dart
  /// await message.pin();
  /// ```
  Future<void> pin() async {
    await _datastore.message.pin(channelId, id);
  }

  /// Unpin the message.
  ///
  /// ```dart
  /// await message.unpin();
  /// ```
  Future<void> unpin() async {
    await _datastore.message.unpin(channelId, id);
  }

  /// Crosspost the message.
  ///
  /// ```dart
  /// await message.crosspost(); // only works for guild announcements
  /// ```
  Future<void> crosspost() async {
    final channel = await resolveChannel();
    if (channel.type != ChannelType.guildAnnouncement) {
      return;
    }

    await _datastore.message.crosspost(channelId, id);
  }

  /// Delete the message.
  ///
  /// ```dart
  /// await message.delete();
  /// ```
  Future<void> delete() => _datastore.message.delete(channelId, id);
}
