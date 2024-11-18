import 'dart:async';

import 'package:mineral/container.dart';
import 'package:mineral/src/api/common/color.dart';
import 'package:mineral/src/api/common/embed/message_embed.dart';
import 'package:mineral/src/api/common/embed/message_embed_assets.dart';
import 'package:mineral/src/api/common/embed/message_embed_field.dart';
import 'package:mineral/src/api/common/embed/message_embed_provider.dart';
import 'package:mineral/src/api/common/embed/message_embed_type.dart';
import 'package:mineral/src/infrastructure/commons/helper.dart';
import 'package:mineral/src/infrastructure/commons/utils.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';

final class EmbedSerializer implements SerializerContract<MessageEmbed> {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final payload = {
      'title': json['title'],
      'description': json['description'],
      'type': json['type'],
      'url': json['url'],
      'timestamp': json['timestamp'],
      'assets': json['assets'],
      'provider': json['provider'],
      'fields': json['fields'],
      'color': json['color']
    };

    final cacheKey = _marshaller.cacheKey.embed(json['id']);
    await _marshaller.cache.put(cacheKey, payload);

    return payload;
  }

  @override
  MessageEmbed serialize(Map<String, dynamic> json) {
    return MessageEmbed(
      title: json['title'],
      description: json['description'],
      type: Helper.createOrNull(
          field: json['type'],
          fn: () => findInEnum(MessageEmbedType.values, json['type'])),
      url: json['url'],
      timestamp: Helper.createOrNull(
          field: json['timestamp'],
          fn: () => DateTime.tryParse(json['timestamp'])),
      assets: Helper.createOrNull(
          field: json['assets'],
          fn: () => MessageEmbedAssets.fromJson(json['assets'])),
      provider: Helper.createOrNull(
          field: json['provider'],
          fn: () => MessageEmbedProvider.fromJson(json['provider'])),
      fields: Helper.createOrNull(
          field: json['fields'],
          fn: () => List.from(json['fields'])
              .map((element) => MessageEmbedField.fromJson(element))
              .toList()),
      color: Helper.createOrNull(
          field: json['color'], fn: () => Color.of(json['color'])),
    );
  }

  @override
  Map<String, dynamic> deserialize(MessageEmbed embed) {
    final assets = embed.assets?.toJson();

    return {
      'title': embed.title,
      'description': embed.description,
      'type': embed.type,
      'url': embed.url,
      'timestamp': embed.timestamp?.toIso8601String(),
      'fields': embed.fields?.map((field) => field.toJson()).toList(),
      'color': embed.color?.toInt(),
      ...assets!,
    };
  }
}
