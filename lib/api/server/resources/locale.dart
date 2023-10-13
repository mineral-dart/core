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

  static Locale from(final String locale) {
    for (final Locale l in Locale.values) {
      if (l.locale == locale) {
        return l;
      }
    }
    throw ArgumentError.value(locale, 'locale', 'Unknown locale');
  }
}