final class GuildRepository {
  /// Get guild
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#get-guild)
  /// ```dart
  /// final uri = http.endpoints.guilds.get('1234');
  /// ```
  String get(String guildId) => Uri(pathSegments: ['guilds', guildId]).path;

  /// Get guild preview
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#get-guild-preview)
  /// ```dart
  /// final uri = http.endpoints.guilds.getPreview('1234');
  /// ```
  String getPreview(String guildId) => Uri(pathSegments: ['guilds', guildId, 'preview']).path;

  /// Modify guild
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#modify-guild)
  /// ```dart
  /// final uri = http.endpoints.guilds.update('1234');
  /// ```
  String update(String guildId) => Uri(pathSegments: ['guilds', guildId]).path;

  /// Delete guild
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#delete-guild)
  /// ```dart
  /// final uri = http.endpoints.guilds.delete('1234');
  /// ```
  String delete(String guildId) => Uri(pathSegments: ['guilds', guildId]).path;

  /// Get guild channels
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#get-guild-channels)
  /// ```dart
  /// final uri = http.endpoints.guilds.getChannels('1234');
  /// ```
  String getChannels(String guildId) => Uri(pathSegments: ['guilds', guildId, 'channels']).path;

  /// Create guild channel
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#create-guild-channel)
  /// ```dart
  /// final uri = http.endpoints.guilds.createChannel('1234');
  /// ```
  String createChannel(String guildId) => Uri(pathSegments: ['guilds', guildId, 'channels']).path;

  /// Modify guild channel positions
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#modify-guild-channel-positions)
  /// ```dart
  /// final uri = http.endpoints.guilds.updateChannelPositions('1234');
  /// ```
  String updateChannelPositions(String guildId) => Uri(pathSegments: ['guilds', guildId, 'channels']).path;

  /// Get guild member
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#get-guild-member)
  /// ```dart
  /// final uri = http.endpoints.guilds.getMember('1234');
  /// ```
  String getMember(String guildId) => Uri(pathSegments: ['guilds', guildId, 'members']).path;

  /// Search guild members
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#search-guild-members)
  /// ```dart
  /// final uri = http.endpoints.guilds.searchMembers('1234');
  /// ```
  String searchMembers(String guildId) => Uri(pathSegments: ['guilds', guildId, 'members', 'search']).path;

  /// Add guild member
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#add-guild-member)
  /// ```dart
  /// final uri = http.endpoints.guilds.addMember('1234');
  /// ```
  String addMember(String guildId) => Uri(pathSegments: ['guilds', guildId, 'members']).path;

  /// Modify guild member
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#modify-guild-member)
  /// ```dart
  /// final uri = http.endpoints.guilds.updateMember('1234');
  /// ```
  String updateMember(String guildId) => Uri(pathSegments: ['guilds', guildId, 'members']).path;

  /// Modify current user's nick
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#modify-current-member)
  /// ```dart
  /// final uri = http.endpoints.guilds.updateCurrentUserNick('987741097889517643');
  /// ```
  String updateCurrentUserNick(String guildId) => Uri(pathSegments: ['guilds', guildId, 'members', '@me', 'nick']).path;

  /// Add guild member role
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#add-guild-member-role)
  /// ```dart
  /// final uri = http.endpoints.guilds.addMemberRole(
  ///   '987741097889517643',
  ///   '987741097889517643',
  ///   '987741097889517643'
  /// );
  /// ```
  String addMemberRole(String guildId, String userId, String roleId) =>
      Uri(pathSegments: ['guilds', guildId, 'members', userId, 'roles', roleId]).path;

  /// Remove guild member role
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#remove-guild-member-role)
  /// ```dart
  /// final uri = http.endpoints.guilds.removeMemberRole('240561194958716928');
  /// ```
  String removeMemberRole(String guildId, String userId, String roleId) =>
      Uri(pathSegments: ['guilds', guildId, 'members', userId, 'roles', roleId]).path;

  /// Remove guild member
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#remove-guild-member)
  /// ```dart
  /// final uri = http.endpoints.guilds.removeMember('240561194958716928');
  /// ```
  String removeMember(String guildId, String userId) =>
      Uri(pathSegments: ['guilds', guildId, 'members', userId]).path;

  /// Get guild bans
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#get-guild-bans)
  /// ```dart
  /// final uri = http.endpoints.guilds.getBans('240561194958716928');
  /// ```
  String getBans(String guildId) => Uri(pathSegments: ['guilds', guildId, 'bans']).path;

  /// Get guild ban
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#get-guild-ban)
  /// ```dart
  /// final uri = http.endpoints.guilds.getBan('240561194958716928');
  /// ```
  String getBan(String guildId, String userId) =>
      Uri(pathSegments: ['guilds', guildId, 'bans', userId]).path;

  /// Create guild ban
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#create-guild-ban)
  /// ```dart
  /// final uri = http.endpoints.guilds.createBan('240561194958716928');
  /// ```
  String createBan(String guildId, String userId) =>
      Uri(pathSegments: ['guilds', guildId, 'bans', userId]).path;

  /// Remove guild ban
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#remove-guild-ban)
  /// ```dart
  /// final uri = http.endpoints.guilds.removeBan('240561194958716928');
  /// ```
  String removeBan(String guildId, String userId) =>
      Uri(pathSegments: ['guilds', guildId, 'bans', userId]).path;

  /// Get guild roles
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#get-guild-roles)
  /// ```dart
  /// final uri = http.endpoints.guilds.getRoles('240561194958716928');
  /// ```
  String getRoles(String guildId) => Uri(pathSegments: ['guilds', guildId, 'roles']).path;

  /// Create guild role
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#create-guild-role)
  /// ```dart
  /// final uri = http.endpoints.guilds.createRole('240561194958716928');
  /// ```
  String createRole(String guildId) => Uri(pathSegments: ['guilds', guildId, 'roles']).path;

  /// Modify guild role positions
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#modify-guild-role-positions)
  /// ```dart
  /// final uri = http.endpoints.guilds.updateRolePositions('240561194958716928');
  /// ```
  String updateRolePositions(String guildId) => Uri(pathSegments: ['guilds', guildId, 'roles']).path;

  /// Modify guild role
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#modify-guild-role)
  /// ```dart
  /// final uri = http.endpoints.guilds.updateRole('240561194958716928');
  /// ```
  String updateRole(String guildId, String roleId) =>
      Uri(pathSegments: ['guilds', guildId, 'roles', roleId]).path;

  /// Delete guild role
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#delete-guild-role)
  /// ```dart
  /// final uri = http.endpoints.guilds.deleteRole('240561194958716928');
  /// ```
  String deleteRole(String guildId, String roleId) =>
      Uri(pathSegments: ['guilds', guildId, 'roles', roleId]).path;

  /// Modify guild MFA level
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#modify-guild-mfa-level)
  /// ```dart
  /// final uri = http.endpoints.guilds.updateMFALevel('240561194958716928');
  /// ```
  String updateMFALevel(String guildId) =>
      Uri(pathSegments: ['guilds', guildId, 'mfa']).path;

  /// Get guild prune count
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#get-guild-prune-count)
  /// ```dart
  /// final uri = http.endpoints.guilds.getPruneCount('240561194958716928');
  /// ```
  String getPruneCount(String guildId) =>
      Uri(pathSegments: ['guilds', guildId, 'prune']).path;

  /// Begin guild prune
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#begin-guild-prune)
  /// ```dart
  /// final uri = http.endpoints.guilds.beginPrune('240561194958716928');
  /// ```
  String beginPrune(String guildId) =>
      Uri(pathSegments: ['guilds', guildId, 'prune']).path;

  /// Get guild voice regions
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#get-guild-voice-regions)
  /// ```dart
  /// final uri = http.endpoints.guilds.getVoiceRegions('240561194958716928');
  /// ```
  String getVoiceRegions(String guildId) =>
      Uri(pathSegments: ['guilds', guildId, 'regions']).path;

  /// Get guild invites
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#get-guild-invites)
  /// ```dart
  /// final uri = http.endpoints.guilds.getInvites('240561194958716928');
  /// ```
  String getInvites(String guildId) =>
      Uri(pathSegments: ['guilds', guildId, 'invites']).path;

  /// Get guild integrations
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#get-guild-integrations)
  /// ```dart
  /// final uri = http.endpoints.guilds.getIntegrations('240561194958716928');
  /// ```
  String getIntegrations(String guildId) =>
      Uri(pathSegments: ['guilds', guildId, 'integrations']).path;

  /// Delete guild integration
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#create-guild-integration)
  /// ```dart
  /// final uri = http.endpoints.guilds.deleteIntegration('240561194958716928');
  /// ```
  String deleteIntegration(String guildId, String integrationId) =>
      Uri(pathSegments: ['guilds', guildId, 'integrations', integrationId]).path;

  /// Get guild widget settings
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#get-guild-widget-settings)
  /// ```dart
  /// final uri = http.endpoints.guilds.getWidgetSettings('240561194958716928');
  /// ```
  String getWidgetSettings(String guildId) =>
      Uri(pathSegments: ['guilds', guildId, 'widget']).path;

  /// Modify guild widget settings
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#modify-guild-widget-settings)
  /// ```dart
  /// final uri = http.endpoints.guilds.updateWidgetSettings('240561194958716928');
  /// ```
  String updateWidgetSettings(String guildId) =>
      Uri(pathSegments: ['guilds', guildId, 'widget']).path;

  /// Get guild widget
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#get-guild-widget)
  /// ```dart
  /// final uri = http.endpoints.guilds.getWidget('240561194958716928');
  /// ```
  String getWidget(String guildId) =>
      Uri(pathSegments: ['guilds', guildId, 'widget.json']).path;

  /// Get guild vanity url
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#get-guild-vanity-url)
  /// ```dart
  /// final uri = http.endpoints.guilds.getVanityUrl('240561194958716928');
  /// ```
  String getVanityUrl(String guildId) =>
      Uri(pathSegments: ['guilds', guildId, 'vanity-url']).path;

  /// get guild widget image
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#get-guild-widget-image)
  /// ```dart
  /// final uri = http.endpoints.guilds.getWidgetImage('240561194958716928');
  /// ```
  String getWidgetImage(String guildId) =>
      Uri(pathSegments: ['guilds', guildId, 'widget.png']).path;

  /// Get guild welcome screen
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#get-guild-welcome-screen)
  /// ```dart
  /// final uri = http.endpoints.guilds.getWelcomeScreen('240561194958716928');
  /// ```
  String getWelcomeScreen(String guildId) =>
      Uri(pathSegments: ['guilds', guildId, 'welcome-screen']).path;

  /// Modify guild welcome screen
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#modify-guild-welcome-screen)
  /// ```dart
  /// final uri = http.endpoints.guilds.updateWelcomeScreen('240561194958716928');
  /// ```
  String updateWelcomeScreen(String guildId) =>
      Uri(pathSegments: ['guilds', guildId, 'welcome-screen']).path;

  /// Get guild onboarding welcome screen
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#get-guild-onboarding)
  /// ```dart
  /// final uri = http.endpoints.guilds.getOnboardingScreen('240561194958716928');
  /// ```
  String getOnboardingScreen(String guildId) =>
      Uri(pathSegments: ['guilds', guildId, 'onboarding']).path;

  /// Modify guild onboarding welcome screen
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#modify-guild-onboarding)
  /// ```dart
  /// final uri = http.endpoints.guilds.updateOnboardingScreen('240561194958716928');
  /// ```
  String updateOnboardingScreen(String guildId) =>
      Uri(pathSegments: ['guilds', guildId, 'onboarding']).path;

  /// Modify current user voice state
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#modify-current-user-voice-state)
  /// ```dart
  /// final uri = http.endpoints.guilds.updateCurrentUserVoiceState('240561194958716928');
  /// ```
  String updateCurrentUserVoiceState(String guildId) =>
      Uri(pathSegments: ['guilds', guildId, 'voice-states', '@me']).path;

  /// Modify user voice state
  /// Related [official documentation](https://discord.com/developers/docs/resources/guild#modify-user-voice-state)
  /// ```dart
  /// final uri = http.endpoints.guilds.updateUserVoiceState('240561194958716928');
  /// ```
  String updateUserVoiceState(String guildId, String userId) =>
      Uri(pathSegments: ['guilds', guildId, 'voice-states', userId]).path;

  String get t => '';
}