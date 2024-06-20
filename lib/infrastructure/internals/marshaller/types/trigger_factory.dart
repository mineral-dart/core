import 'dart:async';

import 'package:mineral/api/server/auto_mod/enums/trigger_type.dart';

abstract interface class TriggerFactory<T> {
  TriggerType get type;
  FutureOr<T> serialize(Map<String, dynamic> json);
  FutureOr<Map<String, dynamic>> deserialize(T object);
}
