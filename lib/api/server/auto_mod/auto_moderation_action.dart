import 'package:mineral/api/server/auto_mod/enums/action_type.dart';

abstract interface class AutoModerationAction {
  ActionType get type;
  Map<String, dynamic> toJson();
}
