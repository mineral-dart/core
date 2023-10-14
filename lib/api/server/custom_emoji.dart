import 'package:mineral/api/common/emojis/emoji.dart';
import 'package:mineral/api/common/snowflake.dart';

class CustomEmoji implements Emoji {
  @override
  String label;

  final Snowflake id;
  bool isAnimated;
  bool? isManaged;

  CustomEmoji({
    required this.label,
    required this.id,
    required this.isAnimated,
    this.isManaged,
  });

  @override
  String toString() => '<:$label:$id>';
  // todo methods: https://discord.com/developers/docs/resources/emoji#emoji-resource

  factory CustomEmoji.from(final payload) =>
    CustomEmoji(
      label: payload['name'],
      id: Snowflake(payload['id']),
      isAnimated: payload['animated'],
      isManaged: payload['managed'],
    );
}