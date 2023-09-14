/// GuildTemplate object
/// Related to the official [Discord API](https://discord.com/developers/docs/resources/guild_template) documentation
final class GuildTemplateRepository {
  /// Get a guild template
  /// Related to the official [Discord API](https://discord.com/developers/docs/resources/guild-template#get-guild-template) documentation
  /// ```dart
  /// final template = await http.endpoints.guildTemplates.get('1234567890');
  /// ```
  String get({ required String templateCode }) =>
      Uri(pathSegments: ['guilds', 'templates', templateCode]).path;

  /// Create a guild from a template
  /// Related to the official [Discord API](https://discord.com/developers/docs/resources/guild-template#create-guild-from-guild-template) documentation
  /// ```dart
  /// final template = await http.endpoints.guildTemplates.create('1234567890');
  /// ```
    String create({ required String templateCode }) =>
        Uri(pathSegments: ['guilds', 'templates', templateCode]).path;

  /// Get a guild's templates
  /// Related to the official [Discord API](https://discord.com/developers/docs/resources/guild-template#get-guild-templates) documentation
  /// ```dart
  /// final templates = await http.endpoints.guildTemplates.list('1234567890');
  /// ```
  String list({ required String guildId }) =>
      Uri(pathSegments: ['guilds', guildId, 'templates']).path;

  /// Create a guild template
  /// Related to the official [Discord API](https://discord.com/developers/docs/resources/guild-template#create-guild-template) documentation
  /// ```dart
  /// final template = await http.endpoints.guildTemplates.create('1234567890');
  /// ```
  String createTemplate({ required String guildId }) =>
      Uri(pathSegments: ['guilds', guildId, 'templates']).path;

  /// Sync a guild template
  /// Related to the official [Discord API](https://discord.com/developers/docs/resources/guild-template#sync-guild-template) documentation
  /// ```dart
  /// final template = await http.endpoints.guildTemplates.sync('1234567890');
  /// ```
  String sync({ required String guildId, required String templateCode }) =>
      Uri(pathSegments: ['guilds', guildId, 'templates', templateCode]).path;

  /// Update a guild template
  /// Related to the official [Discord API](https://discord.com/developers/docs/resources/guild-template#modify-guild-template) documentation
  /// ```dart
  /// final template = await http.endpoints.guildTemplates.update('1234567890');
  /// ```
  String update({ required String guildId, required String templateCode }) =>
      Uri(pathSegments: ['guilds', guildId, 'templates', templateCode]).path;

  /// Delete a guild template
  /// Related to the official [Discord API](https://discord.com/developers/docs/resources/guild-template#delete-guild-template) documentation
  /// ```dart
  /// final template = await http.endpoints.guildTemplates.delete('1234567890');
  /// ```
  String delete({ required String guildId, required String templateCode }) =>
      Uri(pathSegments: ['guilds', guildId, 'templates', templateCode]).path;
}