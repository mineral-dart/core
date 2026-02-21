abstract interface class LoggerContract {
  void trace(Object message);

  void fatal(Exception message);

  void error(String message);

  void warn(String message);

  void info(String message);
}
