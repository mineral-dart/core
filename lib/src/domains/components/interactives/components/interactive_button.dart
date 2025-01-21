import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/components/interactives/components/interactive_component.dart';

abstract interface class InteractiveButton implements InteractiveComponent<ButtonBuilderContract> {
  FutureOr<void> handle(ButtonContext ctx);
}
