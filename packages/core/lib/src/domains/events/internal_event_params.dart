import 'package:mineral/src/domains/events/event.dart';

final class InternalEventParams {
  final Event event;
  final List params;
  final bool Function(String?)? constraint;

  const InternalEventParams(this.event, this.params, this.constraint);
}
