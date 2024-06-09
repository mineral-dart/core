import 'package:mineral/api/server/auto_mod/auto_moderation_action.dart';
import 'package:mineral/api/server/auto_mod/enums/action_type.dart';

final class TimeoutAction implements AutoModerationAction {
  @override
  final ActionType type = ActionType.timeout;

  final Duration duration;

  TimeoutAction({required this.duration});
}
