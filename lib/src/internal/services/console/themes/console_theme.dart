import 'package:mineral/src/internal/services/console/theme.dart';
import 'package:tint/tint.dart';

class ConsoleTheme extends Theme {
  ConsoleTheme(): super(
    inputPrefix: '?'.padRight(2).yellow(),
    successPrefix: '[ ' + 'success'.padRight(2).green() + ' ]',
    errorPrefix: '[ error ]'.padRight(2).red(),
    booleanPrefix: '(y/n)'.padLeft(2).grey(),
    pickedItemPrefix: '❯'.green(),
    infoPrefix: '[ ' + 'success'.padRight(2).cyan() + ' ]',
    warnPrefix: '[ warn ]'.yellow(),
  );
}