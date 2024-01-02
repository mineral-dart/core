import 'package:mineral/api/common/sticker.dart';
import 'package:mineral/api/server/role.dart';

final class StickerCollection {
  final Map<String, Sticker> _stickers;

  StickerCollection(this._stickers);

  Map<String, Sticker> get list => _stickers;

  factory StickerCollection.fromJson(List<dynamic> payload) {
    final Map<String, Sticker> stickers = payload.fold({}, (value, element) {
      final sticker = Sticker.fromJson(element);
      return {...value, sticker.id: sticker};
    });

    return StickerCollection(stickers);
  }
}
