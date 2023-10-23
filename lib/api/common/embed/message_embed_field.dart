final class MessageEmbedField {
  final String name;
  final String value;
  final bool inline;

  MessageEmbedField({
    required this.name,
    required this.value,
    this.inline = false
  });

  Map<String, String?> get serializeAsJson => {
    'name': name,
    'value': value,
    'inline': inline.toString()
  };
}