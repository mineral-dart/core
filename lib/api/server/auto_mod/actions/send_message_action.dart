import 'package:mineral/api/server/auto_mod/auto_moderation_action.dart';
import 'package:mineral/api/server/auto_mod/enums/action_type.dart';

final class SendMessageAction implements AutoModerationAction {
  @override
  final ActionType type = ActionType.sendAlertMessage;

  final String channelId;

  SendMessageAction({required this.channelId});
}
