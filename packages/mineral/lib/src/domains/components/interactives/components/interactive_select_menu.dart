import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/components/interactives/components/interactive_component.dart';

abstract interface class InteractiveSelectMenu<T extends dynamic>
    implements InteractiveComponent<SelectMenu<T>> {
  FutureOr<void> handle(SelectContext ctx, T values);
}
