import 'package:mineral/domains/events/event.dart';

final class InternalEventParams {
  final Event event;
  final List params;

  const InternalEventParams(this.event, this.params);
}