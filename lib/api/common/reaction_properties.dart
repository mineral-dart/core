import 'package:mineral/api/common/emoji.dart';
import 'package:mineral/api/common/message.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';

final class ReactionProperties<T extends Message> {
  final int count;
  final Snowflake? guildId;
  final Member? member;
  final Emoji emoji;
  final Snowflake? authorId;
  final bool burst;
  final List<String> burstColors;


  ReactionProperties({
    required this.count,
    required this.guildId,
    required this.member,
    required this.emoji,
    required this.authorId,
    required this.burst,
    required this.burstColors,
  });

  factory ReactionProperties.fromJson(Map<String, dynamic> json) {
    final marshaller = Marshaller.singleton();
    final emoji = marshaller.serializers.emojis.serialize({
      ...json['emoji'],
      'guildRoles': json['guildRoles'] ?? [],
      'roles': json['roles'] ?? [],
    }) as Emoji;

    return ReactionProperties(
      count: json['count'],
      guildId: json['guild_id'] != null ? Snowflake(json['guild_id']) : null,
      member: json['member'] != null ? Marshaller.singleton().serializers.member.serialize(json['member']) as Member : null,
      emoji: emoji,
      authorId: json['author_id'] != null ? Snowflake(json['author_id']) : null,
      burst: json['burst'] ?? false,
      burstColors: List.from(json['burst_colors'] ?? []),
    );
  }
}