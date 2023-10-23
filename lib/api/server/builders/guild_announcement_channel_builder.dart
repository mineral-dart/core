import 'package:mineral/api/common/snowflake.dart';

final class GuildAnnouncementChannelBuilder {
  final Map<String, dynamic> _fields = {};

  GuildAnnouncementChannelBuilder();

  GuildAnnouncementChannelBuilder setName(String name) {
    _fields['name'] = name;
    return this;
  }

  GuildAnnouncementChannelBuilder setTopic(String topic) {
    _fields['topic'] = topic;
    return this;
  }

  GuildAnnouncementChannelBuilder setPosition(int position) {
    _fields['position'] = position;
    return this;
  }

  GuildAnnouncementChannelBuilder setNsfw(bool isNsfw) {
    _fields['nsfw'] = isNsfw;
    return this;
  }

  GuildAnnouncementChannelBuilder setParentId(Snowflake parentId) {
    _fields['parent_id'] = parentId;
    return this;
  }

  Map<String, dynamic> build() {
    return _fields;
  }
}