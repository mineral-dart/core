import 'package:mineral/api/common/snowflake.dart';

final class GuildVoiceChannelBuilder {
  final Map<String, dynamic> _fields = {};

  GuildVoiceChannelBuilder();

  GuildVoiceChannelBuilder setName(String name) {
    _fields['name'] = name;
    return this;
  }

  GuildVoiceChannelBuilder setPosition(int position) {
    _fields['position'] = position;
    return this;
  }

  GuildVoiceChannelBuilder setParent(Snowflake parentId) {
    _fields['parent_id'] = parentId;
    return this;
  }

  GuildVoiceChannelBuilder setBitrate(int bitrate) {
    _fields['bitrate'] = bitrate;
    return this;
  }

  GuildVoiceChannelBuilder setUserLimit(int value) {
    _fields['user_limit'] = value;
    return this;
  }

  Map<String, dynamic> build() {
    return _fields;
  }
}