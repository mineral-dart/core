import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/emoji.dart';
import 'package:mineral/src/api/common/snowflake.dart';

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
  Future<Emoji?> get(String id, {bool force = false}) => _datastore.emoji.get(_serverId.value, id, force);
}
