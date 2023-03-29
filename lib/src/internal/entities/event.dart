import 'package:mineral_contract/mineral_contract.dart';

abstract class Event {}

abstract class MineralEvent<Event> extends MineralEventContract {
  final Type listener = Event;

  String? customId;

  Future<void> handle (Event event);
}
