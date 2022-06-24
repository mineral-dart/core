part of api;

class VerificationLevel {
  static int none = 0;
  static int low = 1;
  static int medium = 2;
  static int high = 3;
  static int veryHigh = 4;
}

class NswLevel {
  static int initial = 0;
  static int explicit = 1;
  static int medium = 2;
  static int high = 3;
  static int veryHigh = 4;
}

class PremiumTier {
  static int none = 0;
  static int firstTier = 1;
  static int secondTier = 2;
  static int thirdTier = 3;
}

class SuppressChannelFlag {
  static int joinNotification = 1 << 0;
  static int premiumSubscriptions = 1 << 1;
  static int guildReminderNotifications = 1 << 2;
  static int joinNotificationReplies = 1 << 3;
}

enum GuildFeature {
  animatedBanner,
  animatedIcon,
  banner,
  commerce,
  community,
  discoverable,
  featurable,
  inviteSplash,
  memberVerificationGateEnabled,
  monetizationEnabled,
  moreStickers,
  news,
  PARTNERED,
  PREVIEW_ENABLED,
  PRIVATE_THREADS,
  ROLE_ICONS,
  TICKETED_EVENTS_ENABLED,
  VANITY_URL,
  VERIFIED,
  VIP_REGIONS,
  WELCOME_SCREEN_ENABLED,
}

enum ArchiveDuration {
  oneHour(60),
  oneDay(1440),
  threeDays(4320),
  oneWeek(10080);

  final int duration;

  const ArchiveDuration(this.duration);

  @override
  String toString () => duration.toString();
}

enum ThreadType {
  public(11),
  private(12);

  final int scope;

  const ThreadType (this.scope);

  @override
  String toString () => scope.toString();
}