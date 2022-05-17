import 'package:mineral/src/api/channels/channel.dart';
import 'package:mineral/src/constants.dart';

class VoiceChannel extends Channel {
  int? bitrate;
  int? userLimit;
  int? rateLimitPerUser;
  String? rtcRegion;
  int? videoQualityMode;

  VoiceChannel({
    required Snowflake id,
    required Snowflake? guildId,
    required int? position,
    required String label,
    required Snowflake? applicationId,
    required Snowflake? parentId,
    required int? flags,
    required this.bitrate,
    required this.userLimit,
    required this.rateLimitPerUser,
    required this.rtcRegion,
    required this.videoQualityMode,
  }) : super(
    id: id,
    type: ChannelType.guildVoice,
    guildId: guildId,
    position: position,
    label: label,
    applicationId: applicationId,
    parentId: parentId,
    flags: flags,
  );
}
