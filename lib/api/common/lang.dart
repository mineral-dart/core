enum Lang {
  id('id', 'Indonesian'),
  da('da', 'Danish'),
  de('de', 'German'),
  enGB('en-GB',	'UK	English'),
  enUS('en-US', 'US	English'),
  esES('es-ES', 'Spanish'),
  fr('fr', 'French'),
  hr('hr', 'Croatian'),
  it('it', 'Italian'),
  lt('lt', 'Lithuanian'),
  hu('hu', 'Hungarian'),
  nl('nl', 'Dutch'),
  no('no', 'Norwegian'),
  pl('pl', 'Polish'),
  pt('pt-BR',	'Portuguese'),
  ro('ro', 'Romanian'),
  fi('fi', 'Finnish'),
  svSE('sv-SE', 'Swedish'),
  vi('vi', 'Vietnamese'),
  tr('tr', 'Turkish'),
  cs('cs', 'Czech'),
  el('el', 'Greek'),
  bg('bg', 'Bulgarian'),
  ru('ru', 'Russian'),
  uk('uk', 'Ukrainian'),
  hi('hi', 'Hindi'),
  th('th', 'Thai'),
  zh('zh-CN', 'Chinese'),
  ja('ja', 'Japanese'),
  zhTW('zh-TW',	'Chinese'),
  ko('ko', 'Korean');

  final String uid;
  final String label;

  const Lang(this.uid, this.label);
}
