final class GuildCategoryChannelBuilder {
  final Map<String, dynamic> _fields = {};

  GuildCategoryChannelBuilder();

  GuildCategoryChannelBuilder setName(String name) {
    _fields['name'] = name;
    return this;
  }

  GuildCategoryChannelBuilder setPosition(int position) {
    _fields['position'] = position;
    return this;
  }

  Map<String, dynamic> build() {
    return _fields;
  }
}