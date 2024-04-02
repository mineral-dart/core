import 'package:mineral/api/common/color.dart';
import 'package:mineral/api/common/embed/message_embed_assets.dart';
import 'package:mineral/api/common/embed/message_embed_field.dart';
import 'package:mineral/api/common/embed/message_embed_provider.dart';
import 'package:mineral/api/common/embed/message_embed_type.dart';
import 'package:mineral/domains/shared/helper.dart';
import 'package:mineral/domains/shared/utils.dart';

final class MessageEmbed {
  final String? title;
  final String? description;
  final MessageEmbedType? type;
  final String? url;
  final DateTime? timestamp;
  final MessageEmbedAssets? assets;
  final MessageEmbedProvider? provider;
  final List<MessageEmbedField>? fields;
  final Color? color;

  MessageEmbed({
    this.title,
    this.description,
    this.url,
    this.timestamp,
    this.assets,
    this.fields,
    this.type,
    this.provider,
    this.color,
  });

  Object toJson() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'url': url,
      'timestamp': timestamp?.toIso8601String(),
      'assets': assets?.toJson(),
      'fields': fields?.map((field) => field.toJson()).toList(),
      'color': color?.toInt()
    };
  }

  factory MessageEmbed.fromJson(dynamic json) {
    return MessageEmbed(
      title: json['title'],
      description: json['description'],
      type: Helper.createOrNull(
          field: json['type'], fn: () => findInEnum(MessageEmbedType.values, json['type'])),
      url: json['url'],
      timestamp: Helper.createOrNull(
          field: json['timestamp'], fn: () => DateTime.tryParse(json['timestamp'])),
      assets: Helper.createOrNull(
          field: json['assets'], fn: () => MessageEmbedAssets.fromJson(json['assets'])),
      provider: Helper.createOrNull(
          field: json['provider'], fn: () => MessageEmbedProvider.fromJson(json['provider'])),
      fields: Helper.createOrNull(
          field: json['fields'], fn: () => json['fields'].map(MessageEmbedField.fromJson).toList()),
      color: Helper.createOrNull(
          field: json['color'], fn: () => Color.of(json['color'])),
    );
  }
}
