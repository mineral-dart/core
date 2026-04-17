import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/private/user.dart';
import 'package:mineral/src/domains/commands/command_context.dart';

final class GlobalCommandContext extends CommandContext {
  final User user;

  GlobalCommandContext({
    required super.id,
    required super.applicationId,
    required super.token,
    required super.version,
    required this.user,
    super.channel,
  });

  static Future<GlobalCommandContext> fromMap(MarshallerContract marshaller,
      DataStoreContract datastore, Map<String, dynamic> payload) async {
    final memberMap = payload['member'] as Map<String, dynamic>;
    final memberUser = memberMap['user'] as Map<String, dynamic>;
    final (user, channel) = await (
      datastore.user.get(memberUser['id'] as String, false),
      datastore.channel.get(payload['channel_id'] as String, false)
    ).wait;

    return GlobalCommandContext(
      id: Snowflake.parse(payload['id']),
      applicationId: Snowflake.parse(payload['application_id']),
      token: payload['token'] as String,
      version: payload['version'] as int,
      user: user!,
      channel: channel,
    );
  }
}
