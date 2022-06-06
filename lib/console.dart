library console;

class Console {
  static void log ({ required String message}) {
    print(message);
  }

  static debug ({ String prefix = 'debug', required String message }) {
    String p = ColorList.white(prefix);
    print("[ $p ] $message");
  }

  static info ({ String prefix = 'info', required String message }) {
    String p = ColorList.blue(prefix);
    print("[ $p ] $message");
  }

  static success ({ String prefix = 'success', required String message }) {
    String p = ColorList.green(prefix);
    print("[ $p ] $message");
  }

  static error ({ String prefix = 'error', required String message }) {
    print(getErrorMessage(prefix: ColorList.red(prefix), message: message));
  }

  static warn ({ String prefix = 'warn', required String message }) {
    print(getWarnMessage(prefix: ColorList.yellow(prefix), message: message));
  }

  static String getWarnMessage ({ String? prefix = 'warn', required String message }) {
    String p = ColorList.yellow(prefix!);
    return "[ $p ] $message";
  }

  static String getErrorMessage ({ String? prefix = 'error', required String message }) {
    String p = ColorList.red(prefix!);
    return "[ $p ] $message";
  }
}

class ColorList {
  static String black (String text) => '\x1B[30m$text\x1B[0m';
  static String red (String text) => '\x1B[31m$text\x1B[0m';
  static String green (String text) => '\x1B[32m$text\x1B[0m';
  static String yellow (String text) => '\x1B[33m$text\x1B[0m';
  static String blue (String text) => '\x1B[34m$text\x1B[0m';
  static String magenta (String text) => '\x1B[35m$text\x1B[0m';
  static String cyan (String text) => '\x1B[36m$text\x1B[0m';
  static String white (String text) => '\x1B[37m$text\x1B[0m';
}
