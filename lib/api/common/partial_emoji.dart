class PartialEmoji {
  final String id;
  final String name;

  const PartialEmoji(this.name, this.id);

  factory PartialEmoji.fromJson(Map<String, dynamic> json) {
    return PartialEmoji(
      json['id'],
      json['name'],
    );
  }
}
