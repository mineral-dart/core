import 'package:mineral/internal/factories/contracts/event_contract.dart';
import 'package:mineral/internal/services/intents/intents.dart';
import 'package:mineral/services/env/environment.dart';

abstract class ApplicationConfigContract {
  final String token;
  final Intents intents;
  late final bool hmr;
  late final String appEnv;
  List<EventContract Function()> events;

  Environment get env => Environment.singleton();

  ApplicationConfigContract({ required this.token, required this.intents, String hmr = 'false', required this.appEnv, required this.events }) {
    this.hmr = bool.parse(hmr);
  }
}