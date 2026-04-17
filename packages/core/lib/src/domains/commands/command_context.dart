import 'package:mineral/src/api/common/channel.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/domains/services/interactions/interaction_contract.dart';
import 'package:mineral/src/infrastructure/internals/interactions/interaction.dart';

abstract class CommandContext {
  final Snowflake id;
  final Snowflake applicationId;
  final String token;
  final int version;

  /// The channel in which the command was invoked, if available.
  final Channel? channel;

  late final InteractionContract interaction = Interaction(token, id);

  CommandContext({
    required this.id,
    required this.applicationId,
    required this.token,
    required this.version,
    this.channel,
  });
}
