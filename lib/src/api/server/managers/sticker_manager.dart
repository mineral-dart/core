import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/common/sticker.dart';

final class StickerManager {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  final Snowflake _serverId;

  StickerManager(this._serverId);

  /// Fetch the server's stickers.
  /// ```dart
  /// final channels = await server.assets.stickers.fetch();
  /// ```
  Future<Map<Snowflake, Sticker>> fetch({bool force = false}) =>
      _datastore.sticker.fetch(_serverId.value, force);

  /// Get a channel by its id.
  /// ```dart
  /// final channel = await server.assets.stickers.get('1091121140090535956');
  /// ```
  Future<Sticker?> get(String id, {bool force = false}) => _datastore.sticker.get(_serverId.value, id, force);
}
