/// Repository for [User]
/// Related official [documentation](https://discord.com/developers/docs/resources/user)
final class UserRepository {
  /// Get current user from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/user#get-current-user)
  /// ```dart
  /// final uri = http.endpoints.users.current();
  /// ```
  String current() => Uri(pathSegments: ['users', '@me']).path;

  /// Get one user from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/user#get-user)
  /// ```dart
  /// final uri = http.endpoints.users.one('1234');
  /// ```
  String one({ required String userId }) =>
      Uri(pathSegments: ['users', userId]).path;

  /// Modify current user from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/user#modify-current-user)
  /// ```dart
  /// final uri = http.endpoints.users.updateCurrent();
  /// ```
  String updateCurrent() => Uri(pathSegments: ['users', '@me']).path;

  /// Get current user guilds from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/user#get-current-user-guilds)
  /// ```dart
  /// final uri = http.endpoints.users.currentGuilds();
  /// ```
  String currentGuilds() => Uri(pathSegments: ['users', '@me', 'guilds']).path;

  /// Get current [GuildMember] from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#get-guild-member)
  /// ```dart
  /// final uri = http.endpoints.users.currentGuildMember('1234');
  /// ```
  String currentGuildMember({ required String guildId }) =>
      Uri(pathSegments: ['users', '@me', 'guilds', guildId, 'members']).path;

  /// Leave guild from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/user#leave-guild)
  /// ```dart
  /// final uri = http.endpoints.users.leaveGuild('1234');
  /// ```
  String leaveGuild({ required String guildId }) =>
      Uri(pathSegments: ['users', '@me', 'guilds', guildId]).path;

  /// Create DM channel from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/user#create-dm)
  /// ```dart
  /// final uri = http.endpoints.users.createDM();
  /// ```
  String createDM() => Uri(pathSegments: ['users', '@me', 'channels']).path;

  /// Create group DM channel from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/user#create-group-dm)
  /// ```dart
  /// final uri = http.endpoints.users.createGroupDM();
  /// ```
  String createGroupDM() => Uri(pathSegments: ['users', '@me', 'channels']).path;

  /// Get user connections from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/user#get-user-connections)
  /// ```dart
  /// final uri = http.endpoints.users.connections();
  /// ```
  String connections() => Uri(pathSegments: ['users', '@me', 'connections']).path;

  /// Get user application role connections from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/user#get-user-application-role-connection)
  /// ```dart
  /// final uri = http.endpoints.users.currentApplication(applicationId: '1234');
  /// ```
  String currentApplication({ required String applicationId }) =>
      Uri(pathSegments: ['users', '@me', 'applications', applicationId, 'role-connection']).path;

  /// Update user application role connections from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/user#update-user-application-role-connection)
  /// ```dart
  /// final uri = http.endpoints.users.updateCurrentApplication(applicationId: '1234');
  /// ```
  String updateCurrentApplication({ required String applicationId }) =>
      Uri(pathSegments: ['users', '@me', 'applications', applicationId, 'role-connection']).path;

  String get t => '';
}