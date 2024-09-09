import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/private/private_message.dart';
import 'package:mineral/src/api/private/user.dart';
import 'package:mineral/src/domains/components/buttons/button_context.dart';
import 'package:mineral/src/infrastructure/internals/interactions/interaction.dart';
import 'package:mineral/src/infrastructure/internals/interactions/types/interaction_contract.dart';

final class PrivateButtonContext implements ButtonContext {
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

  final User user;

  final PrivateMessage message;

  late final InteractionContract interaction;

  PrivateButtonContext({
    required this.id,
    required this.applicationId,
    required this.token,
    required this.version,
    required this.customId,
    required this.message,
    required this.user,
  }) {
    interaction = Interaction(token, id);
  }
}
