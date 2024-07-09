import 'package:mineral/api/common/snowflake.dart';

abstract class CommandContext {
  final Snowflake id;
  final Snowflake applicationId;
  final String token;
  final int version;

  CommandContext({
    required this.id,
    required this.applicationId,
    required this.token,
    required this.version,
  });

  Future<void> reply();
}