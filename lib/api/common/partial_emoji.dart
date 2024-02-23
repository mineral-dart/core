import 'package:mineral/api/common/snowflake.dart';

class PartialEmoji {
  final Snowflake id;
  final String name;

  const PartialEmoji(this.id, this.name);

  factory PartialEmoji.fromJson(Map<String, dynamic> json) {
    return PartialEmoji(
      Snowflake(json['id']),
      json['name'],
    );
  }
}
