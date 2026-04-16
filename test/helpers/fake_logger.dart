import 'package:mineral/contracts.dart';

final class FakeLogger implements LoggerContract {
  final List<String> warnings = [];
  final List<String> errors = [];
  final List<Object> traces = [];
  final List<String> infos = [];

  @override
  void trace(Object message) => traces.add(message);
  @override
  void fatal(Exception message) {}
  @override
  void error(String message) => errors.add(message);
  @override
  void warn(String message) => warnings.add(message);
  @override
  void info(String message) => infos.add(message);
}
