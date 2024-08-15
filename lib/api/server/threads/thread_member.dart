import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';

final class ThreadMember {
  final Snowflake id;
  final Snowflake userId;
  final DateTime joinedAt;
  final int flags;
  final Member member;

  ThreadMember({
    required this.id,
    required this.userId,
    required this.joinedAt,
    required this.flags,
    required this.member,
  });

  static Future<ThreadMember> serialize(MarshallerContract marshaller, Map<String, dynamic> json) async {
    final serverCacheKey = marshaller.cacheKey.serverMember(serverId: json['guild_id'], memberId: json['owner_id']);
    final rawMember = await marshaller.cache.getOrFail(serverCacheKey);
    final member = await marshaller.serializers.member.serializeCache(rawMember);

    return ThreadMember(
      id: Snowflake(json['id']),
      userId: Snowflake(json['owner_id']),
      joinedAt: DateTime.parse(json['joined_at'] ?? DateTime.now().toIso8601String()),
      flags: json['flags'],
      member: member,
    );
  }
}