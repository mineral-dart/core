import 'package:mineral/src/api/common/commands/builder/translation.dart';
import 'package:mineral/src/api/common/lang.dart';

final class CommandHelper {
  Map<String, String>? extractTranslations(
      String key, Translation translations) {
    if (translations.translations[key] case final Map<Lang, String> elements) {
      return elements.entries.fold({}, (acc, element) {
        return {...?acc, element.key.uid: element.value};
      });
    }

    return null;
  }
}
