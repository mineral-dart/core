import 'package:mineral/src/domains/events/event.dart';

final class InternalEventParams {
  final Event event;
  final Object payload;
  final bool Function(String?)? constraint;

  const InternalEventParams(this.event, this.payload, this.constraint);
}
