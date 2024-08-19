import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/private/user.dart';
import 'package:mineral/domains/commands/command_context.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';

final class GlobalCommandContext implements CommandContext {
  @override
  final Snowflake id;
  @override
  final Snowflake applicationId;
  @override
  final String token;
  @override
  final int version;

  final User user;
  final Channel? channel;

  GlobalCommandContext({
    required this.id,
    required this.applicationId,
    required this.token,
    required this.version,
    required this.user,
    this.channel,
  });

  static Future<GlobalCommandContext> fromMap(
      MarshallerContract marshaller, Map<String, dynamic> payload) async {
    return GlobalCommandContext(
      id: Snowflake(payload['id']),
      applicationId: Snowflake(payload['application_id']),
      token: payload['token'],
      version: payload['version'],
      user: await marshaller.dataStore.user.getUser(Snowflake(payload['member']['user']['id'])),
      channel: await marshaller.dataStore.channel.getChannel(Snowflake(payload['channel_id'])),
    );
  }
}
