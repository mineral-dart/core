import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/channel.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/private/user.dart';
import 'package:mineral/src/domains/commands/command_context.dart';
import 'package:mineral/src/infrastructure/internals/interactions/interaction.dart';

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
    final (user, channel) = await (
      datastore.user.get(payload['member']['user']['id'], false),
      datastore.channel.get(payload['channel_id'], false)
    ).wait;

    return GlobalCommandContext(
      id: Snowflake.parse(payload['id']),
      applicationId: Snowflake.parse(payload['application_id']),
      token: payload['token'],
      version: payload['version'],
      user: user!,
      channel: channel,
    );
  }
}
