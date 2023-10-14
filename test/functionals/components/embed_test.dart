import 'package:mineral/api/common/embed/color.dart';
import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/embed/message_embed_builder.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main () {
  test('Can create MessageEmbed from MessageEmbedBuilder', () {
    final embed = MessageEmbedBuilder()
      .setTitle('title')
      .setDescription('description')
      .setUrl(Uri.parse('https://example.com'))
      .setTimestamp(DateTime.now())
      .setColor(Color.cyan_400)
      .build();

    expect(embed, isA<MessageEmbed>());
    expect(embed.title, equals('title'));
    expect(embed.description, equals('description'));
    expect(embed.url, isA<Uri>());
    expect(embed.timestamp, isA<DateTime>());
    expect(embed.color, allOf([
      isA<Color>(),
      equals(Color.cyan_400)
    ]));
  });
}