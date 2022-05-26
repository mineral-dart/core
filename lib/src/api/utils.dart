part of api;

class VerificationLevel {
  static int none = 0;
  static int low = 1;
  static int medium = 2;
  static int high = 3;
  static int veryHigh = 4;
}

class NsfwLevel {
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

enum Locale {
  da('da'),
  de('de'),
  enGB('en-GB'),
  enUS('en-US'),
  esES('es-ES'),
  fr('fr'),
  hr('hr'),
  it('it'),
  lt('lt'),
  hu('hu'),
  nl('nl'),
  no('no'),
  pl('pl'),
  ptBR('pt-BR'),
  ro('ro'),
  fi('fi'),
  svSE('sv-SE'),
  vi('vi'),
  tr('tr'),
  cs('cs'),
  el('el'),
  bg('bg'),
  ru('ru'),
  uk('uk'),
  hi('hi'),
  th('th'),
  zhCN('zh-CN'),
  ja('ja'),
  zhTW('zh-TW'),
  ko('ko');

  final String locale;
  const Locale(this.locale);

  @override
  String toString() => locale;
}

enum Feature {
  animatedBanner('ANIMATED_BANNER'),
  animatedIcon('ANIMATED_ICON'),
  banner('BANNER'),
  commerce('COMMERCE'),
  community('COMMUNITY'),
  discoverable('DISCOVERABLE'),
  featurable('FEATURABLE'),
  inviteSplash('INVITE_SPLASH'),
  memberVerificationGate('MEMBER_VERIFICATION_GATE_ENABLED'),
  monetizationEnabled('MONETIZATION_ENABLED'),
  moreSticker('MORE_STICKERS'),
  news('NEWS'),
  partnered('PARTNERED'),
  previewEnabled('PREVIEW_ENABLED'),
  privateThread('PRIVATE_THREADS'),
  roleIcons('ROLE_ICONS'),
  ticketedEventsEnabled('TICKETED_EVENTS_ENABLED'),
  vanityUrl('VANITY_URL'),
  verified('VERIFIED'),
  vipRegions('VIP_REGIONS'),
  welcomeScreenEnabled('WELCOME_SCREEN_ENABLED');

  final String feature;
  const Feature(this.feature);

  @override
  String toString() => feature;
}

enum MessageFlag {
  crossPosted(1 << 0),
  isCrossPost(1 << 1),
  suppressEmbeds(1 << 2),
  sourceMessageDeleted(1 << 3),
  urgent(1 << 4),
  hasThread(1 << 5),
  ephemeral(1 << 6),
  loading(1 << 7),
  failedToMentionSomeRolesInThread(1 << 8);

  final int value;
  const MessageFlag(this.value);
}
