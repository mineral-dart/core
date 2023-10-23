import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/internal/services/http/discord_http_client.dart';
import 'package:mineral/services/http/entities/either.dart';
import 'package:mineral/services/http/entities/http_error.dart';
import 'package:mineral/services/http/entities/http_payload.dart';

final class SendableMessage {
  Future<void> sendToGuildTextChannel(Snowflake channelId, List<MessageEmbed>? embeds, String? content, String? tts) async {
    final http = DiscordHttpClient.singleton();

    final request = http.post('/channels/${channelId.value}/messages')
      .payload({
        'embeds': embeds?.map((embed) => embed.serializeAsJson).toList(),
        'content': content,
        'tts': tts,
      })
      .build();

    await Either.future(
      future: request,
      onSuccess: (HttpPayload response) => response.body,
      onError: (HttpError error) => switch(error) {
        HttpError(message: final message)
          => throw ArgumentError(message),
      }
    );
  }
}