import 'package:mineral/api/common/snowflake.dart';

final class GuildTextChannelBuilder {
  final Map<String, dynamic> _fields = {};

  GuildTextChannelBuilder();

  GuildTextChannelBuilder setName(String name) {
    _fields['name'] = name;
    return this;
  }

  GuildTextChannelBuilder setTopic(String topic) {
    _fields['topic'] = topic;
    return this;
  }

  GuildTextChannelBuilder setPosition(int position) {
    _fields['position'] = position;
    return this;
  }

  GuildTextChannelBuilder setNsfw(bool isNsfw) {
    _fields['nsfw'] = isNsfw;
    return this;
  }

  GuildTextChannelBuilder setRateLimitPerUser(int rateLimitPerUser) {
    _fields['rate_limit_per_user'] = rateLimitPerUser;
    return this;
  }

  GuildTextChannelBuilder setParentId(Snowflake parentId) {
    _fields['parent_id'] = parentId;
    return this;
  }

  Map<String, dynamic> build() {
    return _fields;
  }
}