import 'package:mineral/domains/events/event.dart';

final class InternalEventParams {
  final Event event;
  final List params;
  final Map<Symbol, dynamic>? namedParams;

  const InternalEventParams(this.event, this.params, this.namedParams);
}
