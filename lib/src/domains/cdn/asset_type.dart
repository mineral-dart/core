final class AssetType {
  static String customEmoji(String emojiId, Format format) => 'emojis/$emojiId.$format';

  static String guildIcon(String guildId, Format format) => 'icons/$guildId/guild_icon.$format';

  static String guildSplash(String guildId, Format format) => 'splashes/$guildId/guild_splash.$format';

  static String guildDiscoverySplash(String guildId, Format format) => 'discovery-splashes/$guildId/guild_discovery_splash.$format';

  static String guildBanner(String guildId, Format format) => 'banners/$guildId/guild_banner.$format';

  static String userBanner(String userId, Format format) => 'banners/$userId/user_banner.$format';

  static String defaultUserAvatar(Format format) => 'embed/avatars/index.$format';

  static String userAvatar(String userId, Format format) => 'avatars/$userId/user_avatar.$format';

  static String guildMemberAvatar(String guildId, String userId, Format format) => 'guilds/$guildId/users/$userId/avatars/member_avatar.$format';

  static String avatarDecoration(Format format) => 'avatar-decoration-presets/avatar_decoration_data_asset.$format';

  static String applicationIcon(String applicationId, Format format) => 'app-icons/$applicationId/icon.$format';

  static String applicationCover(String applicationId, Format format) => 'app-icons/$applicationId/cover_image.$format';

  static String applicationAsset(String applicationId, Format format) => 'app-assets/$applicationId/asset_id.$format';

  static String storePageAsset(String applicationId, Format format) => 'app-assets/$applicationId/store/asset_id.$format';

  static String stickerPackBanner(String stickerPackId, Format format) => 'app-assets/$stickerPackId/store/sticker_pack_banner_asset_id.$format';

  static String teamIcon(String teamId, Format format) => 'team-icons/$teamId/team_icon.$format';

  static String sticker(String stickerId, Format format) => 'stickers/$stickerId.$format';

  static String roleIcon(String roleId, Format format) => 'role-icons/$roleId/role_icon.$format';

  static String guildScheduledEventCover(String scheduledEventId, Format format) => 'guild-events/$scheduledEventId/scheduled_event_cover_image.$format';
}

enum Format {
  svg('svg'),
  png('png'),
  gif('gif'),
  webp('webp');

  final String value;

  const Format(this.value);
}
