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
