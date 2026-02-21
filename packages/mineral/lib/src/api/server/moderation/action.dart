import 'package:mineral/src/api/server/moderation/action_metadata.dart';
import 'package:mineral/src/api/server/moderation/enums/action_type.dart';

final class Action {
  final ActionType type;
  final ActionMetadata? metadata;

  Action({
    required this.type,
    this.metadata,
  });
}