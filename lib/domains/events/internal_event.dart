import 'dart:async';

final class InternalEvent {
  final String event;
  final FutureOr<void> Function() handle;

  const InternalEvent(this.event, this.handle);
}
