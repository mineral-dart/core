abstract class LoggerContract {
  void log(dynamic message);

  void error(dynamic message);

  void warning(dynamic message);

  void success(dynamic message);

  void info(dynamic message);

  void debug(dynamic message);
}