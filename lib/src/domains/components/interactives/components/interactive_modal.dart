import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/components/interactives/components/interactive_component.dart';

abstract interface class InteractiveModal<T extends dynamic>
    implements InteractiveComponent<ModalBuilder> {
  FutureOr<void> handle(ModalContext ctx, T values);
}
