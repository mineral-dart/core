import 'package:mineral/src/api/common/types/interaction_type.dart';

abstract class InteractionDispatcherContract {
  InteractionType get type;
  Future<void> dispatch(Map<String, dynamic> data);
}
