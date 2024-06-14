import 'package:mineral/api/server/auto_mod/auto_moderation_action.dart';
import 'package:mineral/api/server/auto_mod/enums/action_type.dart';

final class BlockMessageAction implements AutoModerationAction {
  @override
  final ActionType type = ActionType.blockMessage;

  final String? message;

  BlockMessageAction({this.message});

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'custom_message': message,
    };
  }
}
