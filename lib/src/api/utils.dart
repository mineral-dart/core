enum InteractionType {
  ping(1),
  applicationCommand(2),
  messageComponent(3),
  applicationCommandAutocomplete(4),
  modalSubmit(5);

  final int value;
  const InteractionType(this.value);
}

enum ContextMenuType {
  user(2),
  message(3);

  final int value;
  const ContextMenuType(this.value);
}

enum ApplicationCommandType {
  chatInput(1),
  user(2),
  message(3);

  final int value;
  const ApplicationCommandType(this.value);
}

enum ExplicitContentFilterLevel {
  disabled(0),
  membersWithoutRoles(1),
  allMembers(2);

  final int _value;
  const ExplicitContentFilterLevel(this._value);

  @override
  String toString() => _value.toString();
}

enum SystemChannelFlags {
  suppressJoinNotifications(1 << 0),
  suppressPremiumSubscriptions(1 << 1),
  suppressGuildReminderNotifications(1 << 2),
  suppressJoinNotificationReplies(1 << 3);

  final int _value;
  const SystemChannelFlags(this._value);

  @override
  String toString() => _value.toString();
}

class NsfwLevel {
  static int initial = 0;
  static int explicit = 1;
  static int medium = 2;
  static int high = 3;
  static int veryHigh = 4;
}

class SuppressChannelFlag {
  static int joinNotification = 1 << 0;
  static int premiumSubscriptions = 1 << 1;
  static int guildReminderNotifications = 1 << 2;
  static int joinNotificationReplies = 1 << 3;
}

enum Locale {
  da('da', null),
  de('de', null),
  enGB('en-GB', 'en'),
  enUS('en-US', 'en'),
  esES('es-ES', 'es'),
  fr('fr', null),
  hr('hr', null),
  it('it', null),
  lt('lt', null),
  hu('hu', null),
  nl('nl', null),
  no('no', null),
  pl('pl', null),
  ptBR('pt-BR', 'pt'),
  ro('ro', null),
  fi('fi', null),
  svSE('sv-SE', 'sv'),
  vi('vi', null),
  tr('tr', null),
  cs('cs', null),
  el('el', null),
  bg('bg', null),
  ru('ru', null),
  uk('uk', null),
  hi('hi', null),
  th('th', null),
  zhCN('zh-CN', 'zh'),
  ja('ja', null),
  zhTW('zh-TW', null),
  ko('ko', null);

  final String _locale;
  final String? _normalize;

  const Locale(this._locale, this._normalize);

  String get locale => _locale;
  String get normalize => _normalize ?? _locale;

  @override
  String toString() => locale;
}

enum GuildFeature {
  animatedBanner('ANIMATED_BANNER'),
  animatedIcon('ANIMATED_ICON'),
  autoModeration('AUTO_MODERATION'),
  banner('BANNER'),
  commerce('COMMERCE'),
  community('COMMUNITY'),
  discoverable('DISCOVERABLE'),
  featurable('FEATURABLE'),
  inviteSplash('INVITE_SPLASH'),
  memberVerificationGate('MEMBER_VERIFICATION_GATE_ENABLED'),
  monetization('MONETIZATION_ENABLED'),
  moreStickers('MORE_STICKERS'),
  news('NEWS'),
  threads('THREADS_ENABLED'),
  newThreadPermissions('NEW_THREAD_PERMISSIONS'),
  textInVoiceChannel('TEXT_IN_VOICE_ENABLED'),
  partnered('PARTNERED'),
  preview('PREVIEW_ENABLED'),
  privateThreads('PRIVATE_THREADS'),
  threeDayThreadArchive('THREE_DAY_THREAD_ARCHIVE'),
  roleIcons('ROLE_ICONS'),
  ticketedEvents('TICKETED_EVENTS_ENABLED'),
  vanityUrl('VANITY_URL'),
  verified('VERIFIED'),
  vipRegions('VIP_REGIONS'),
  welcomeScreen('WELCOME_SCREEN_ENABLED'),
  memberProfiles('MEMBER_PROFILES'),
  sevenDayThreadArchive('SEVEN_DAY_THREAD_ARCHIVE'),
  applicationCommandPermissionsV2('APPLICATION_COMMAND_PERMISSIONS_V2'),
  soundboard('SOUNDBOARD');

  final String value;
  const GuildFeature(this.value);

  @override
  String toString() => value;
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