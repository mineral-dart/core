import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/sticker_manager.dart';

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
  late StickerManager manager;

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

  Future<void> setName (String name) async {
    Http http = ioc.singleton(Service.http);

    Response response = await http.patch("/guilds/$guildId/stickers/$id", { 'name': name });
    if (response.statusCode == 200) {
      this.name = name;
    }
  }

  Future<void> setDescription (String description) async {
    Http http = ioc.singleton(Service.http);

    Response response = await http.patch("/guilds/$guildId/stickers/$id", { 'description': description });
    if (response.statusCode == 200) {
      this.description = description;
    }
  }

  Future<void> setTags (String tags) async {
    Http http = ioc.singleton(Service.http);

    Response response = await http.patch("/guilds/$guildId/stickers/$id", { 'tags': tags });
    if (response.statusCode == 200) {
      this.tags = tags;
    }
  }

  Future<void> delete () async {
    Http http = ioc.singleton(Service.http);

    Response response = await http.destroy("/guilds/$guildId/stickers/$id");
    if (response.statusCode == 200) {
      manager.cache.remove(id);
    }
  }

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
