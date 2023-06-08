import 'package:mineral/core/api.dart';

class Translate {
  final Map<Lang, String> _translations;

  Translate(this._translations);

  Map<String, String> get serialize =>
    _translations.entries.fold({}, (previousValue, element) => {
      ...previousValue,
      element.key.uid: element.value
    });
}