abstract interface class GuildVoiceChannelContract {
  abstract final String id;
  abstract String name;
  abstract int position;
  abstract int bitrate;
  abstract int userLimit;
  abstract String? parentId;
}