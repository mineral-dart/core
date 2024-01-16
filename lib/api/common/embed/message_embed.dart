import 'package:mineral/api/common/embed/message_embed_assets.dart';
import 'package:mineral/api/common/embed/message_embed_field.dart';
import 'package:mineral/api/common/embed/message_embed_provider.dart';
import 'package:mineral/api/common/embed/message_embed_type.dart';
import 'package:mineral/domains/shared/utils.dart';

final class MessageEmbed {
  final String? title;
  final String? description;
  final MessageEmbedType? type;
  final String? url;
  final DateTime? timestamp;
  final MessageEmbedAssets? assets;
  final MessageEmbedProvider? provider;
  final List<MessageEmbedField> fields;

  MessageEmbed({
    required this.title,
    required this.description,
    required this.url,
    required this.timestamp,
    required this.assets,
    required this.fields,
    this.type,
    this.provider,
  }) {
    expectOrThrow(fields.length <= 25, message: 'Fields must be 25 or fewer in length');
  }

  factory MessageEmbed.fromJson(Map<String, dynamic> json) {
    return MessageEmbed(
      title: json['title'],
      description: json['description'],
      type: createOrNull(
          field: json['type'], fn: () => findInEnum(MessageEmbedType.values, json['type'])),
      url: json['url'],
      timestamp: DateTime.tryParse(json['timestamp']),
      assets: MessageEmbedAssets.fromJson(json['assets']),
      provider: createOrNull(
          field: json['provider'], fn: () => MessageEmbedProvider.fromJson(json['provider'])),
      fields: json['fields'].map(MessageEmbedField.fromJson).toList(),
    );
  }
}
