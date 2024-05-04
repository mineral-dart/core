import 'package:collection/collection.dart';
import 'package:mineral/api/common/color.dart';
import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/embed/message_embed_assets.dart';
import 'package:mineral/api/common/embed/message_embed_field.dart';
import 'package:mineral/api/common/embed/message_embed_provider.dart';
import 'package:mineral/api/common/embed/message_embed_type.dart';
import 'package:mineral/api/common/emoji.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/role.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';
import 'package:mineral/domains/shared/helper.dart';
import 'package:mineral/domains/shared/utils.dart';

final class EmbedSerializer implements SerializerContract<MessageEmbed> {
  final MarshallerContract _marshaller;

  EmbedSerializer(this._marshaller);

  @override
  MessageEmbed serialize(Map<String, dynamic> json) {
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
      color: Helper.createOrNull(field: json['color'], fn: () => Color.of(json['color'])),
    );
  }

  @override
  Map<String, dynamic> deserialize(MessageEmbed embed) {
    return {
      'title': embed.title,
      'description': embed.description,
      'type': embed.type,
      'url': embed.url,
      'timestamp': embed.timestamp?.toIso8601String(),
      'assets': embed.assets?.toJson(),
      'fields': embed.fields?.map((field) => field.toJson()).toList(),
      'color': embed.color?.toInt()
    };
  }
}
