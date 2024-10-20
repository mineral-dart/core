import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/infrastructure/internals/interactions/types/interaction_contract.dart';

abstract class CommandContext {
  final Snowflake id;
  final Snowflake applicationId;
  final String token;
  final int version;
  late final InteractionContract interaction;

  CommandContext({
    required this.id,
    required this.applicationId,
    required this.token,
    required this.version,
  });
}
