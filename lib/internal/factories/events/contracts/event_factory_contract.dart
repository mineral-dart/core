import 'package:mineral/internal/factories/events/contracts/event_contract.dart';

abstract interface class EventFactoryContract {
  void register<T extends EventContract> (T Function() event);
  void registerMany<T extends EventContract>(List<T Function()> events);
}