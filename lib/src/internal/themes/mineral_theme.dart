import 'package:mineral_cli/mineral_cli.dart';

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