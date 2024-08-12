import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';

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

  static Future<ThreadMember> serialize(MarshallerContract marshaller, Map<String, dynamic> json, Server server) async {
    return ThreadMember(
      id: Snowflake(json['id']),
      userId: Snowflake(json['owner_id']),
      joinedAt: DateTime.parse(json['joined_at'] ?? DateTime.now().toIso8601String()),
      flags: json['flags'],
      member: json['owner_id'] != null ? server.members.get(json['owner_id']) : null,
    );
  }
}