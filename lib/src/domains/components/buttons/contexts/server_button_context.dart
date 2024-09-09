import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/api/server/server_message.dart';
import 'package:mineral/src/domains/components/buttons/button_context.dart';
import 'package:mineral/src/infrastructure/internals/interactions/interaction.dart';
import 'package:mineral/src/infrastructure/internals/interactions/types/interaction_contract.dart';

final class ServerButtonContext implements ButtonContext {
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

  final Member member;

  final ServerMessage message;

  late final InteractionContract interaction;

  ServerButtonContext({
    required this.id,
    required this.applicationId,
    required this.token,
    required this.version,
    required this.customId,
    required this.message,
    required this.member,
  }) {
    interaction = Interaction(token, id);
  }
}
