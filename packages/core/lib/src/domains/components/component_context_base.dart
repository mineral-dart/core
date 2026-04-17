import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/domains/components/component_context.dart';
import 'package:mineral/src/domains/services/interactions/interaction_contract.dart';
import 'package:mineral/src/infrastructure/internals/interactions/interaction.dart';

abstract class ComponentContextBase implements ComponentContext {
  @override
  final Snowflake id;

  @override
  final Snowflake applicationId;

  @override
  final String token;

  @override
  final int version;

  @override
  final String customId;

  @override
  late final InteractionContract interaction = Interaction(token, id);

  ComponentContextBase({
    required this.id,
    required this.applicationId,
    required this.token,
    required this.version,
    required this.customId,
  });
}
