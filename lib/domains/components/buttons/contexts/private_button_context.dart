import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/api/private/user.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/components/buttons/button_context.dart';
import 'package:mineral/infrastructure/internals/interactions/interaction.dart';
import 'package:mineral/infrastructure/internals/interactions/types/interaction_contract.dart';

final class PrivateButtonContext implements ButtonContext {
  @override
  final Snowflake id;

  @override
  final Snowflake applicationId;

  @override
  final String token;

  @override
  final int version;

  final User user;

  final PrivateMessage message;

  late final InteractionContract interaction;

  PrivateButtonContext({
    required this.id,
    required this.applicationId,
    required this.token,
    required this.version,
    required this.message,
    required this.user,
  }) {
    interaction = Interaction(token, id);
  }
}
