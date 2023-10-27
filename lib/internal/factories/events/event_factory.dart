import 'package:mineral/internal/factories/events/contracts/event_contract.dart';
import 'package:mineral/internal/factories/events/contracts/event_factory_contract.dart';
import 'package:mineral/internal/fold/container.dart';
import 'package:mineral/internal/fold/injectable.dart';

final class EventFactory extends Injectable implements EventFactoryContract {
  final List<EventContract> events = [];

  EventFactory();

  @override
  void register<T extends EventContract> (T Function() event) {
    events.add(event());
  }

  @override
  void registerMany<T extends EventContract>(List<T Function()> events) {
    for (final event in events) {
      register(event);
    }
  }

  void dispatch<T extends EventContract>(Function(T event) callback) {
    for (final event in events.whereType<T>()) {
      callback(event);
    }
  }

  factory EventFactory.singleton() => container.use('Mineral/Factories/Event');
}