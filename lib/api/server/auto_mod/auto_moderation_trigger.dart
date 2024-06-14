import 'package:mineral/api/server/auto_mod/enums/trigger_type.dart';

abstract interface class AutoModerationTrigger {
  TriggerType get type;
  Map<String, dynamic> toJson();
}
