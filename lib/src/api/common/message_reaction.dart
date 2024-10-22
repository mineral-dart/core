import 'package:mineral/api.dart';

final class MessageReaction {
  final int count;
  final int burstCount;
  final int normalCount;
  final bool hasReacted;
  final bool hasBurstReacted;
  final PartialEmoji emoji;
  final List<Color> burstColors;

  MessageReaction({
    required this.count,
    required this.burstCount,
    required this.normalCount,
    required this.hasReacted,
    required this.hasBurstReacted,
    required this.emoji,
    required this.burstColors,
  });
}
