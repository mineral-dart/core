import 'package:mineral/api/common/types/format_type.dart';
import 'package:mineral/api/common/types/sticker_type.dart';

final class Sticker {
  final String id;
  final String? packId;
  final String name;
  final String? description;
  final String? tags;
  final String? asset;
  final StickerType type;
  final FormatType? formatType;
  final String? guildId;
  final bool isAvailable;
  final int? sortValue;

  Sticker({
    required this.id,
    required this.name,
    required this.type,
    required this.isAvailable,
    this.packId,
    this.description,
    this.tags,
    this.asset,
    this.formatType,
    this.guildId,
    this.sortValue,
  });

  factory Sticker.fromJson(Map<String, dynamic> json) {
    return Sticker(
      id: json['id'],
      name: json['name'],
      type: StickerType.values.firstWhere((element) => element.value == json['type']),
      isAvailable: json['available'],
      packId: json['pack_id'],
      description: json['description'],
      tags: json['tags'],
      asset: json['asset'],
      formatType: FormatType.values.firstWhere((element) => element.value == json['format_type']),
      guildId: json['guild_id'],
      sortValue: json['sort_value'],
    );
  }
}
