import 'package:mineral/api.dart';

enum StickerType {
  standard(1),
  guild(2);

  final int value;

  const StickerType(this.value);

  @override
  String toString() => value.toString();
}

enum FormatType {
  png(1),
  apgn(2),
  lottie(3);

  final int value;

  const FormatType(this.value);

  @override
  String toString() => value.toString();
}

class Sticker {
  Snowflake id;
  Snowflake packId;
  String name;
  String? description;
  String tags;
  StickerType type;
  FormatType format;
  Snowflake guildId;
  late Guild guild;
  Snowflake? guildMemberId;
  late GuildMember? guildMember;
  int? sortValue;

  Sticker({
    required this.id,
    required this.packId,
    required this.name,
    required this.description,
    required this.tags,
    required this.type,
    required this.format,
    required this.guildId,
    required this.guildMemberId,
    required this.sortValue,
  });

  factory Sticker.from(dynamic payload) {
    dynamic user = payload['user'];

    return Sticker(
      id: payload['id'],
      packId: payload['pack_id'],
      name: payload['name'],
      description: payload['description'],
      tags: payload['tags'],
      type: payload['type'],
      format: payload['format_type'],
      guildId: payload['guild_id'],
      guildMemberId: user['id'],
      sortValue: payload['sortValue']
    );
  }
}
