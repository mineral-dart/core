import 'dart:io';

import 'package:mineral/src/internal/services/console/contracts/theme_contract.dart';
import 'package:mineral_contract/mineral_contract.dart';

class ConsoleService extends ConsoleServiceContract {
  final ThemeContract theme;

  ConsoleService({ required this.theme });

  @override
  void info (String message) {
    stdout.writeln('${theme.infoPrefix} $message');
  }

  @override
  void success (String message) {
    stdout.writeln('${theme.successPrefix} $message');
  }

  @override
  void warn (String message) {
    stdout.writeln('${theme.warnPrefix} $message');
  }

  @override
  void error (String message) {
    stdout.writeln('${theme.errorPrefix} $message');
  }
}