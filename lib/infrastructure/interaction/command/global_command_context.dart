import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/message.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/private/user.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/infrastructure/interaction/command/command_context.dart';

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
  final Member? member;
  final Server? server;
  final Channel? channel;
  final Message? message;

  GlobalCommandContext({
    required this.id,
    required this.applicationId,
    required this.token,
    required this.version,
    required this.user,
    this.member,
    this.server,
    this.channel,
    this.message,
  });

  @override
  Future<void> reply() {
    throw UnimplementedError();
  }
}