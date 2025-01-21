import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/components/interactives/components/interactive_component.dart';

abstract interface class InteractiveDialog implements InteractiveComponent<DialogBuilder> {
  FutureOr<void> handle(DialogContext ctx, options);
}
