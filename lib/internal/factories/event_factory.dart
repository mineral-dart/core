import 'package:mineral/internal/factories/contracts/event_contract.dart';

final class EventFactory {
  final List<EventContract Function()> events = [];

  void dispatch<T extends EventContract>(Function(T event) callback) {
    for (final event in events) {
      if (event is T Function()) {
        callback(event());
      }
    }
  }
}