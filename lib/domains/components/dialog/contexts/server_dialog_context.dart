import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/domains/components/dialog/dialog_context.dart';
import 'package:mineral/infrastructure/internals/interactions/interaction.dart';
import 'package:mineral/infrastructure/internals/interactions/types/interaction_contract.dart';

final class ServerDialogContext implements DialogContext {
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

  late final InteractionContract interaction;

  ServerDialogContext({
    required this.id,
    required this.applicationId,
    required this.token,
    required this.version,
    required this.customId,
    required this.member,
  }) {
    interaction = Interaction(token, id);
  }
}
