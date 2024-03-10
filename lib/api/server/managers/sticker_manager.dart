import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/sticker.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';

final class StickerManager {
  final Map<Snowflake, Sticker> _stickers;

  StickerManager(this._stickers);

  Map<Snowflake, Sticker> get list => _stickers;

  factory StickerManager.fromJson(MarshallerContract marshaller, List<dynamic> payload) {
    final Map<Snowflake, Sticker> stickers = payload.fold({}, (value, element) {
      final sticker = marshaller.serializers.sticker.serialize(element) as Sticker;
      return {...value, sticker.id: sticker};
    });

    return StickerManager(stickers);
  }
}
