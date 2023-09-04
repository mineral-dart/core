import 'package:mineral/src/internal/services/console/theme.dart';
import 'package:tint/tint.dart';

/// Theme used in [ConsoleService] command context
class MineralTheme extends Theme {
  MineralTheme(): super(
    inputPrefix: '[ ' + 'ask'.yellow() + ' ]',
    successPrefix: '[ ' + 'success'.green() + ' ]',
    errorPrefix: '[ ' + 'error'.red() + ' ]',
    booleanPrefix: '(y/n)'.padLeft(2).grey(),
    pickedItemPrefix: '❯'.green(),
    infoPrefix: '[ ' + 'info'.blue() + ' ]',
    warnPrefix: '[ ' + 'warn'.yellow() + ' ]',
  );
}