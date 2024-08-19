import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/sticker.dart';
import 'package:mineral/api/common/types/format_type.dart';
import 'package:mineral/api/common/types/sticker_type.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';

final class StickerSerializer implements SerializerContract<Sticker> {
  @override
  Sticker serializeRemote(Map<String, dynamic> json) => _serialize(json);

  @override
  Sticker serializeCache(Map<String, dynamic> json) => _serialize(json);

  Sticker _serialize(Map<String, dynamic> json) {
    return Sticker(
      id: Snowflake(json['id']),
      name: json['name'],
      type: StickerType.values.firstWhere((element) => element.value == json['type']),
      isAvailable: json['available'],
      packId: json['pack_id'],
      description: json['description'],
      tags: json['tags'],
      asset: json['asset'],
      formatType: FormatType.values.firstWhere((element) => element.value == json['format_type']),
      sortValue: json['sort_value'],
    );
  }

  @override
  Map<String, dynamic> deserialize(Sticker sticker) {
    return {
      'id': sticker.id,
      'name': sticker.name,
      'type': sticker.type.value,
      'available': sticker.isAvailable,
      'pack_id': sticker.packId,
      'description': sticker.description,
      'tags': sticker.tags,
      'asset': sticker.asset,
      'format_type': sticker.formatType?.value,
      'sort_value': sticker.sortValue,
    };
  }
}
