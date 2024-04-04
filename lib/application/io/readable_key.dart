import 'dart:io';

import 'package:mineral/application/io/control_character.dart';
import 'package:mineral/application/io/key_stroke.dart';


final class ReadableKey {
  late KeyStroke keyStroke;
  late int charCode;
  int codeUnit = 0;

  KeyStroke parse() {
    while (codeUnit <= 0) {
      codeUnit = stdin.readByteSync();
    }

    keyStroke = switch (codeUnit) {
      int() when (codeUnit >= 0x01 && codeUnit <= 0x1a) =>
          KeyStroke.control(ControlCharacter.values[codeUnit]),
      int() when codeUnit == 0x1b => escapeSequence(),
      int() when codeUnit == 0x7f => KeyStroke.control(ControlCharacter.backspace),
      int() when codeUnit == 0x09 || (codeUnit >= 0x1c && codeUnit <= 0x1f) => KeyStroke.control(ControlCharacter.unknown),
      _ => KeyStroke.char(String.fromCharCode(codeUnit))
    };

    return keyStroke;
  }

  KeyStroke escapeSequence() {
    final keyStroke = KeyStroke.control(ControlCharacter.escape);
    final List<String> escapeSequence = [];
    charCode = stdin.readByteSync();

    if (charCode == -1) {
      return keyStroke;
    }

    escapeSequence.add(String.fromCharCode(charCode));

    return switch (charCode) {
      int() when charCode == 127 => KeyStroke.control(ControlCharacter.wordBackspace),
      int() when escapeSequence[0] == '[' => getFromChars(escapeSequence),
      int() when escapeSequence[0] == 'O' => getFromSpecialChars(escapeSequence),
      int() when escapeSequence[0] == 'b' => KeyStroke.control(ControlCharacter.wordLeft),
      int() when escapeSequence[0] == 'f' => KeyStroke.control(ControlCharacter.wordRight),
      _ => KeyStroke.control(ControlCharacter.unknown),
    };
  }

  KeyStroke getFromSpecialChars(List<String> sequence) {
    charCode = stdin.readByteSync();
    if (charCode == -1) {
      return keyStroke;
    }

    sequence.add(String.fromCharCode(charCode));

    return switch (sequence[1]) {
      String() when sequence[1] =='H' => KeyStroke.control(ControlCharacter.home),
      String() when sequence[1] =='F' => KeyStroke.control(ControlCharacter.end),
      String() when sequence[1] =='P' => KeyStroke.control(ControlCharacter.f1),
      String() when sequence[1] =='Q' => KeyStroke.control(ControlCharacter.f2),
      String() when sequence[1] =='R' => KeyStroke.control(ControlCharacter.f3),
      String() when sequence[1] =='S' => KeyStroke.control(ControlCharacter.f4),
      _ => KeyStroke.control(ControlCharacter.unknown),
    };
  }

  KeyStroke getFromChars(List<String> sequence) {
    charCode = stdin.readByteSync();
    if (charCode == -1) {
      return keyStroke;
    }

    sequence.add(String.fromCharCode(charCode));

    KeyStroke defaultCase () {
      final isInRange = sequence[1].codeUnits[0] > '0'.codeUnits[0]
          && sequence[1].codeUnits[0] < '9'.codeUnits[0];

      if (isInRange) {
        charCode = stdin.readByteSync();
        if (charCode == -1) {
          return keyStroke;
        }

        sequence.add(String.fromCharCode(charCode));
        if (sequence[2] != '~') {
          return KeyStroke.control(ControlCharacter.unknown);
        } else {
          return switch (sequence[1]) {
            String() when sequence[1] =='1' => KeyStroke.control(ControlCharacter.home),
            String() when sequence[1] =='3' => KeyStroke.control(ControlCharacter.delete),
            String() when sequence[1] =='4' => KeyStroke.control(ControlCharacter.end),
            String() when sequence[1] =='5' => KeyStroke.control(ControlCharacter.pageUp),
            String() when sequence[1] =='6' => KeyStroke.control(ControlCharacter.pageDown),
            String() when sequence[1] =='7' => KeyStroke.control(ControlCharacter.home),
            String() when sequence[1] =='8' => KeyStroke.control(ControlCharacter.end),
            _ => KeyStroke.control(ControlCharacter.unknown),
          };
        }
      }

      return KeyStroke.control(ControlCharacter.unknown);
    }

    return switch (sequence[1]) {
      String() when sequence[1] == 'A' => KeyStroke.control(ControlCharacter.arrowUp),
      String() when sequence[1] == 'B' => KeyStroke.control(ControlCharacter.arrowDown),
      String() when sequence[1] == 'C' => KeyStroke.control(ControlCharacter.arrowRight),
      String() when sequence[1] == 'D' => KeyStroke.control(ControlCharacter.arrowLeft),
      String() when sequence[1] == 'H' => KeyStroke.control(ControlCharacter.home),
      String() when sequence[1] == 'F' => KeyStroke.control(ControlCharacter.end),
      _ => defaultCase()
    };
  }
}
