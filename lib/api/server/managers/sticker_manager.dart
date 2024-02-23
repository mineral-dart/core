import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/sticker.dart';

final class StickerManager {
  final Map<Snowflake, Sticker> _stickers;

  StickerManager(this._stickers);

  Map<Snowflake, Sticker> get list => _stickers;

  factory StickerManager.fromJson(List<dynamic> payload) {
    final Map<Snowflake, Sticker> stickers = payload.fold({}, (value, element) {
      final sticker = Sticker.fromJson(element);
      return {...value, sticker.id: sticker};
    });

    return StickerManager(stickers);
  }
}
