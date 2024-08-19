import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/sticker.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';

final class StickerManager {
  final Map<Snowflake, Sticker> _stickers;

  StickerManager(this._stickers);

  Map<Snowflake, Sticker> get list => _stickers;

  factory StickerManager.fromList(List<Sticker> stickers) {
    return StickerManager(stickers.fold({}, (acc, sticker) {
      return {...acc, sticker.id: sticker};
    }));
  }
}
