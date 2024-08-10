import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/member.dart';

final class ThreadMember {
  final Snowflake id;
  final Snowflake userId;
  final DateTime joinedAt;
  final int flags;
  final Member? member;

  ThreadMember({
    required this.id,
    required this.userId,
    required this.joinedAt,
    required this.flags,
    this.member,
  });
}