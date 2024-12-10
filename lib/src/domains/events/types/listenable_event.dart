import 'package:mineral/src/domains/commons/utils/listenable.dart';
import 'package:mineral/src/domains/events/event.dart';

abstract interface class ListenableEvent implements Listenable {
  Event get event;
  String? get customId;
}
