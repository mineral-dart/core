import 'dart:io';

import 'package:mineral/src/internal/services/console/ansi.dart';
import 'package:mineral/src/internal/services/console/themes/default_theme.dart';

abstract class Component<T> {
  final DefaultTheme theme = DefaultTheme();

  T build ();

  void clearLastLine () {
    stdout.write(ansiCursorLeft + ansiCursorUp);
    stdout.write(' ' * (stdout.terminalColumns + 1));
    stdout.write(ansiCursorLeft + ansiCursorUp + ansiCursorUp);
  }

  void clearScreen () {
    stdout.write('\x1B[2J\x1B[0;0H');
  }

  void updateLastLine (String sentence) {
    clearLastLine();
    stdout.write(sentence);
    _completeWithEmptyLine(sentence.length);
    newLine();
  }

  void _completeWithEmptyLine (int length) {
    stdout.write(' ' * (stdout.terminalColumns - length));
  }

  void newLine () {
    stdout.writeln('');
  }

  void success (String message) {
    stdout.writeln('${theme.successPrefix} $message');
  }
}