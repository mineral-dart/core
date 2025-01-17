import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';

final class EmojiManager {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  final Snowflake _serverId;

  EmojiManager(this._serverId);

  /// Fetch the server's channels.
  /// ```dart
  /// final channels = await server.channels.fetch();
  /// ```
  Future<Map<Snowflake, Emoji>> fetch({bool force = false}) =>
      _datastore.emoji.fetch(_serverId.value, force);

  /// Get a channel by its id.
  /// ```dart
  /// final channel = await server.channels.get('1091121140090535956');
  /// ```
  Future<Emoji?> get(String id, {bool force = false}) =>
      _datastore.emoji.get(_serverId.value, id, force);

  /// Create a new emoji.
  /// ```dart
  /// final emoji = await server.emojis.create(name: 'New Emoji', );
  /// ```
  Future<Emoji> create(
          {required String name,
          required Image image,
          List<Snowflake> roles = const [],
          String? reason}) =>
      _datastore.emoji.create(
          _serverId.value, name, image, roles.map((element) => element.value).toList(),
          reason: reason);
}
