import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/managers/sticker_manager.dart';
import 'package:mineral_ioc/ioc.dart';

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
  Snowflake _id;
  Snowflake? _packId;
  String _name;
  String? _description;
  String _tags;
  StickerType _type;
  FormatType _format;
  int? _sortValue;
  GuildMember? member;
  late StickerManager manager;
  late Guild guild;

  Sticker(
    this._id,
    this._packId,
    this._name,
    this._description,
    this._tags,
    this._type,
    this._format,
    this._sortValue,
  );

  Snowflake get id => _id;
  Snowflake? get packId => _packId;
  String get name => _name;
  String? get description => _description;
  String get tags => _tags;
  StickerType get type => _type;
  FormatType get format => _format;
  int? get sortValue => _sortValue;

  Future<void> setName (String name, { String? reason }) async {
    Response response = await ioc.use<HttpService>().patch(url: "/guilds/${guild.id}/stickers/$id")
      .payload({ 'name': name })
      .auditLog(reason)
      .build();

    if (response.statusCode == 200) {
      _name = name;
    }
  }

  Future<void> setDescription (String description, { String? reason }) async {
    Response response = await ioc.use<HttpService>().patch(url: "/guilds/${guild.id}/stickers/$id")
      .payload({ 'description': description })
      .auditLog(reason)
      .build();

    if (response.statusCode == 200) {
      _description = description;
    }
  }

  Future<void> setTags (String tags, { String? reason }) async {
    Response response = await ioc.use<HttpService>().patch(url: "/guilds/${guild.id}/stickers/$id")
      .payload({ 'tags': tags })
      .auditLog(reason)
      .build();

    if (response.statusCode == 200) {
      _tags = tags;
    }
  }

  Future<void> delete ({ String? reason }) async {
    Response response = await ioc.use<HttpService>().destroy(url: "/guilds/${guild.id}/stickers/$id")
      .auditLog(reason)
      .build();
    
    if (response.statusCode == 200) {
      manager.cache.remove(id);
    }
  }

  factory Sticker.from(dynamic payload) {
    MineralClient client = ioc.use<MineralClient>();

    Guild guild = client.guilds.cache.getOrFail(payload['guild_id']);
    GuildMember? member = guild.members.cache.get(payload['user']?['id']);

    final sticker = Sticker(
      payload['id'],
      payload['pack_id'],
      payload['name'],
      payload['description'],
      payload['tags'],
      StickerType.values.firstWhere((element) => element.value == payload['type']),
      FormatType.values.firstWhere((format) => format.value == payload['format_type']),
      payload['sortValue']
    );

    sticker.guild = guild;
    sticker.member = member;

    return sticker;
  }
}
