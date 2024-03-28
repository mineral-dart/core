import 'package:mineral/application/logger/logger.dart' as logger_service;

mixin Logger {
  logger_service.LoggerContract get logger => logger_service.Logger.singleton();
}
