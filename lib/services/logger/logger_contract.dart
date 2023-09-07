abstract interface class LoggerContract {
  void log(dynamic message);

  void error(String message);

  void warning(String message);

  void success(String message);

  void info(String message);

  void debug(String message);
}