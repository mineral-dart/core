/// Repository for [Sticker] model.
/// Related [official documentation](https://discord.com/developers/docs/resources/sticker)
final class StickerRepository {
  /// Get one sticker from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/sticker#get-sticker)
  /// ```dart
  /// final uri = http.endpoints.stickers.one('1234');
  /// ```
  String one({ required String stickerId }) =>
      Uri(pathSegments: ['stickers', stickerId]).path;

  /// List all sticker packs from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/sticker#list-sticker-packs)
  /// ```dart
  /// final uri = http.endpoints.stickers.listStickerPack();
  /// ```
  String listStickerPack() => Uri(pathSegments: ['sticker-packs']).path;

  /// List all stickers from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/sticker#list-guild-stickers)
  /// ```dart
  /// final uri = http.endpoints.stickers.listGuildStickers('1234');
  /// ```
  String listGuildStickers({ required String guildId }) =>
      Uri(pathSegments: ['guilds', guildId, 'stickers']).path;

  /// Create one sticker from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/sticker#create-guild-sticker)
  /// ```dart
  /// final uri = http.endpoints.stickers.createGuildSticker('1234');
  /// ```
  String createGuildSticker({ required String guildId }) =>
      Uri(pathSegments: ['guilds', guildId, 'stickers']).path;

  /// Modify one sticker from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/sticker#modify-guild-sticker)
  /// ```dart
  /// final uri = http.endpoints.stickers.modifyGuildSticker('1234', '1234');
  /// ```
  String modifyGuildSticker({ required String guildId, required String stickerId }) =>
      Uri(pathSegments: ['guilds', guildId, 'stickers', stickerId]).path;

  /// Delete one sticker from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/sticker#delete-guild-sticker)
  /// ```dart
  /// final uri = http.endpoints.stickers.deleteGuildSticker('1234', '1234');
  /// ```
  String deleteGuildSticker({ required String guildId, required String stickerId }) =>
      Uri(pathSegments: ['guilds', guildId, 'stickers', stickerId]).path;

  String get t => '';
}