import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class DynamicMenuCreateEvent<T> extends Event {
  final DynamicMenu _interaction;

  DynamicMenuCreateEvent(this._interaction);

  DynamicMenu get interaction => _interaction;
}
