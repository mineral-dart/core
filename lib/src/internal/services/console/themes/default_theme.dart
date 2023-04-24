import 'package:mineral/src/internal/services/console/theme.dart';
import 'package:tint/tint.dart';

class DefaultTheme extends Theme {
  DefaultTheme(): super(
    inputPrefix: '?'.padRight(2).yellow(),
    successPrefix: '✓'.padRight(2).green(),
    errorPrefix: '✘'.padRight(2).red(),
    booleanPrefix: '(y/n)'.padLeft(2).grey(),
    pickedItemPrefix: '❯'.green(),
    infoPrefix: '!'.cyan(),
    warnPrefix: '<!>'.yellow(),
  );
}