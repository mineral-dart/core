import 'package:mineral/api/common/sticker.dart';

final class StickerManager {
  final Map<String, Sticker> _stickers;

  StickerManager(this._stickers);

  Map<String, Sticker> get list => _stickers;

  factory StickerManager.fromJson(List<dynamic> payload) {
    final Map<String, Sticker> stickers = payload.fold({}, (value, element) {
      final sticker = Sticker.fromJson(element);
      return {...value, sticker.id: sticker};
    });

    return StickerManager(stickers);
  }
}
