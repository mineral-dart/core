import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/domains/services/interactions/interaction_contract.dart';

abstract interface class ComponentContext {
  Snowflake get id;
  Snowflake get applicationId;
  String get token;
  int get version;
  String get customId;
  InteractionContract get interaction;
}
