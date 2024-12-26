import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/common/sticker.dart';
import 'package:mineral/src/api/common/types/format_type.dart';
import 'package:mineral/src/api/common/types/sticker_type.dart';
import 'package:mineral/src/domains/contracts/marshaller/marshaller.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';

final class StickerSerializer implements SerializerContract<Sticker> {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final payload = {
      'id': json['id'],
      'name': json['name'],
      'type': json['type'],
      'available': json['available'],
      'pack_id': json['pack_id'],
      'description': json['description'],
      'tags': json['tags'],
      'asset': json['asset'],
      'format_type': json['format_type'],
      'sort_value': json['sort_value'],
      'server_id': json['guild_id'],
    };

    final cacheKey =
        _marshaller.cacheKey.sticker(json['guild_id'], json['id']);
    await _marshaller.cache.put(cacheKey, payload);

    return payload;
  }

  @override
  Sticker serialize(Map<String, dynamic> json) {
    return Sticker(
      id: Snowflake(json['id']),
      name: json['name'],
      type: StickerType.values
          .firstWhere((element) => element.value == json['type']),
      isAvailable: json['available'],
      packId: json['pack_id'],
      description: json['description'],
      tags: json['tags'],
      asset: json['asset'],
      formatType: FormatType.values
          .firstWhere((element) => element.value == json['format_type']),
      sortValue: json['sort_value'],
      serverId: Snowflake(json['server_id']),
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
      'server_id': sticker.serverId,
    };
  }
}
