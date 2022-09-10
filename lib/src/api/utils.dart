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

enum NotificationLevel {
  allMessages(0),
  onlyMentions(1);

  final int _value;
  const NotificationLevel(this._value);

  @override
  String toString() => _value.toString();
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
  sevenDayThreadArchive('SEVEN_DAY_THREAD_ARCHIVE');

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
enum Permission {
  createInstantInvite(1 << 0),
  kickMembers(1 << 1),
  banMembers(1 << 2),
  administrator(1 << 3),
  manageChannels(1 << 4),
  manageGuilds(1 << 5),
  addReactions(1 << 6),
  viewAuditChannel(1 << 7),
  prioritySpeaker(1 << 8),
  stream(1 << 9),
  viewChannel(1 << 10),
  sendMessages(1 << 11),
  sendTtsMessage(1 << 12),
  manageMessages(1 << 13),
  embedLinks(1 << 14),
  attachFiles(1 << 15),
  readMessageHistory(1 << 16),
  mentionEveryone(1 << 17),
  useExternalEmojis(1 << 18),
  viewGuildInsights(1 << 19),
  connect(1 << 20),
  speak(1 << 21),
  muteMembers(1 << 22),
  deafenMembers(1 << 23),
  moveMembers(1 << 24),
  useVad(1 << 25),
  changeUsername(1 << 26),
  managerUsernames(1 << 27),
  manageRoles(1 << 28),
  manageWebhooks(1 << 29),
  manageEmojisAndStickers(1 << 30),
  useApplicationCommand(1 << 31),
  requestToSpeak(1 << 32),
  manageEvents(1 << 33),
  manageThreads(1 << 34),
  usePublicThreads(1 << 35),
  createPublicThreads(1 << 35),
  usePrivateThreads(1 << 36),
  createPrivateThreads(1 << 36),
  useExternalStickers(1 << 37),
  sendMessageInThreads(1 << 38),
  startEmbeddedActivities(1 << 39),
  moderateMembers(1 << 40);

  final int _value;
  const Permission(this._value);

  int get value => _value;

  @override
  String toString () {
    return _value.toString();
  }
}
