import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/private/user.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/commands/command_context.dart';

final class ServerCommandContext implements CommandContext {
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
  final Server server;

  ServerCommandContext({
    required this.id,
    required this.applicationId,
    required this.token,
    required this.version,
    required this.user,
    required this.server,
    this.channel,
  });

  @override
  Future<void> reply() {
    throw UnimplementedError();
  }
}
