import 'package:mineral/src/api/common/channel.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/private/user.dart';
import 'package:mineral/src/domains/commands/command_context.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/src/infrastructure/internals/interactions/interaction.dart';
import 'package:mineral/src/infrastructure/internals/interactions/types/interaction_contract.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';

final class GlobalCommandContext implements CommandContext {
  @override
  final Snowflake id;

  @override
  final Snowflake applicationId;

  @override
  final String token;

  @override
  final int version;

  @override
  late final InteractionContract interaction;

  final User user;
  final Channel? channel;

  GlobalCommandContext({
    required this.id,
    required this.applicationId,
    required this.token,
    required this.version,
    required this.user,
    this.channel,
  }) : interaction = Interaction(token, id);

  static Future<GlobalCommandContext> fromMap(MarshallerContract marshaller,
      DataStoreContract datastore, Map<String, dynamic> payload) async {
    return GlobalCommandContext(
      id: Snowflake(payload['id']),
      applicationId: Snowflake(payload['application_id']),
      token: payload['token'],
      version: payload['version'],
      user: await datastore.user
          .getUser(Snowflake(payload['member']['user']['id'])),
      channel:
          await datastore.channel.getChannel(Snowflake(payload['channel_id'])),
    );
  }
}
