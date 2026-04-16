import 'package:mineral/src/domains/events/types/listenable_event.dart';

/// Base class for event contracts that provides the common [customId] field.
/// Subclasses only need to override [event] and declare their [handle] method.
abstract class BaseListenableEvent implements ListenableEvent {
  @override
  String? customId;
}
