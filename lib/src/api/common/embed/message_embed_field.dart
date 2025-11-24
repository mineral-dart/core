import 'package:mineral/src/domains/common/utils/utils.dart';

final class MessageEmbedField {
  final String name;
  final String value;
  final bool isInline;

  MessageEmbedField(
      {required this.name, required this.value, this.isInline = false}) {
    expectOrThrow(name.length <= 256,
        message: 'Name must be 256 or fewer in length');
    expectOrThrow(value.length <= 1024,
        message: 'Value must be 1024 or fewer in length');
  }

  Object toJson() {
    return {
      'name': name,
      'value': value,
      'inline': isInline,
    };
  }

  factory MessageEmbedField.fromJson(Map<String, dynamic> json) {
    return MessageEmbedField(
      name: json['name'],
      value: json['value'],
      isInline: json['inline'],
    );
  }
}
