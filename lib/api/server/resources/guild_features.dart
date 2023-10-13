import 'package:collection/collection.dart';

enum GuildFeature {
  animatedBanner("ANIMATED_BANNER", "Guild has access to set an animated guild banner."),
  animatedIcon("ANIMATED_ICON", "Guild has access to set an animated guild icon."),
  applicationCommandPermissionV2("APPLICATION_COMMAND_PERMISSIONS_V2", "Guild is using the old permissions configuration behavior"),
  autoModeration("AUTO_MODERATION", "Guild has set up auto moderation rules"),
  banner("BANNER", "Guild has access to set a guild banner image."),
  community("COMMUNITY", "Guild can enable welcome screen, Membership Screening, stage channels and discovery, and receives community updates."),
  creatorMonetizableProvisional("CREATOR_MONETIZABLE_PROVISIONAL", "Guild has enabled monetization"),
  creatorStorePage("CREATOR_STORE_PAGE", "Guild has enabled the role subscription promo page"),
  developerSupportServer("DEVELOPER_SUPPORT_SERVER", "Guild has been set as a support server on the App Directory"),
  discoverable("DISCOVERABLE", "Guild is able to be discovered in the directory"),
  featurable("FEATURABLE", "Guild is able to be featured in the directory"),
  invitesDisabled("INVITES_DISABLED", "Guild has disabled invites"),
  inviteSplash("INVITE_SPLASH", "Guild has access to set an invite splash background."),
  memberVerificationGateEnabled("MEMBER_VERIFICATION_GATE_ENABLED", "Guild has enabled Membership Screening"),
  moreSticker("MORE_STICKERS", "Guild has access to more custom stickers"),
  news("NEWS", "Guild has access to set guild news channel"),
  partnered("PARTNERED", "Guild is partnered"),
  previewEnabled("PREVIEW_ENABLED", "Guild can be previewed before joining via Membership Screening or the directory"),
  raidAlertsDisabled("RAID_ALERTS_DISABLED", "Guild has disabled alerts for join raids in the configured safety alerts channel"),
  rolesIcons("ROLES_ICONS", "Guild has access to set role icons"),
  roleSubscriptionsEnabled("ROLE_SUBSCRIPTIONS_ENABLED", "Guild has enabled the role subscription feature"),
  ticketedEventsEnabled("TICKETED_EVENTS_ENABLED", "Guild has enabled ticketed events"),
  vanityUrl("VANITY_URL", "Guild has access to set a vanity URL"),
  verified("VERIFIED", "Guild is verified"),
  vipRegions("VIP_REGIONS", "Guild has access to set 384kbps bitrate in voice (previously VIP voice servers)."),
  welcomeScreenEnabled("WELCOME_SCREEN_ENABLED", "Guild has enabled the welcome screen"),
  guestEnabled("GUESTS_ENABLED", "Guild has guest feature enabled"),
  channelIconEmojisGenerated("CHANNEL_ICON_EMOJIS_GENERATED", "Guild has generated channel icon emojis");

  final String name;
  final String description;

  const GuildFeature(this.name, this.description);

  static GuildFeature? get(final String name) {
    return GuildFeature.values.firstWhereOrNull((e) => e.name == name);
  }
}