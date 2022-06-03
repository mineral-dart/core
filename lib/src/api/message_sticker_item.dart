part of api;

class MessageStickerItem {
  Snowflake id;
  String name;
  FormatType format;

  MessageStickerItem({
    required this.id,
    required this.name,
    required this.format,
  });

  factory MessageStickerItem.from(dynamic payload) {
    print(payload);

    return MessageStickerItem(
      id: payload['id'],
      name: payload['name'],
      format: FormatType.values.firstWhere((element) => element.value == payload['format_type']),
    );
  }
}
