import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/api/common/message_reaction.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';

final class MessageReactionSerializer implements SerializerContract<MessageReaction> {
  final MarshallerContract _marshaller;

  MessageReactionSerializer(this._marshaller);

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final payload = {
      'count': json['count'],
      'count_details': json['count_details'],
      'me': json['me'],
      'me_burst': json['me_burst'],
      'burst_colors': json['burst_colors'],
      'emoji': json['emoji'],
    };

    final cacheKey = _marshaller.cacheKey.reaction(json['id']);
    await _marshaller.cache.put(cacheKey, payload);

    return payload;
  }

  @override
  MessageReaction serialize(Map<String, dynamic> json) {
    return MessageReaction(
      count: json['count'],
      normalCount: json['count_details']['normal'],
      burstCount: json['count_details']['burst'],
      hasReacted: json['me'],
      hasBurstReacted: json['me_burst'],
      burstColors: List.from(json['burst_colors'])
          .map((element) => Color(element))
          .toList(),
      emoji: PartialEmoji.fromEmoji(json['emoji']),
    );
  }

  @override
  Map<String, dynamic> deserialize(MessageReaction reaction) {
    return {
      'count': reaction.count,
      'count_details': {
        'normal': reaction.normalCount,
        'burst': reaction.burstCount,
      },
      'me': reaction.hasReacted,
      'me_burst': reaction.hasBurstReacted,
      'burst_colors': reaction.burstColors.map((color) => color.toString()).toList(),
      'emoji': reaction.emoji.toString(),
    };
  }
}
