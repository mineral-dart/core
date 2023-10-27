import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:mineral/internal/factories/events/contracts/event_contract.dart';
import 'package:mineral/internal/factories/packages/contracts/package_contract.dart';
import 'package:mineral/internal/services/intents/intents.dart';
import 'package:mineral/services/env/environment.dart';

abstract class ApplicationConfigContract {
  final String token;
  final Intents intents;
  late final bool hmr;
  late final String appEnv;

  List<EventContract Function()> events;
  List<PackageContract Function()> packages;

  late final Level logLevel;
  final void Function(LogRecord)? logger;

  Environment get env => Environment.singleton();

  ApplicationConfigContract({
    required this.token,
    required this.intents,
    required this.appEnv,
    required this.events,
    this.packages = const [],
    String hmr = 'false',
    String logLevel = 'INFO',
    this.logger,
  }) {
    this.hmr = bool.parse(hmr);

    final targetLogLevel = Level.LEVELS.firstWhereOrNull((level) => level.name == logLevel);
    this.logLevel = switch(targetLogLevel) {
      Level() => targetLogLevel,
      _ => throw Exception('Invalid log level: $logLevel'),
    };
  }
}