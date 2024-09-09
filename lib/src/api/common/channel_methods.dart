import 'package:mineral/src/api/common/components/message_component.dart';
import 'package:mineral/src/api/common/embed/message_embed.dart';
import 'package:mineral/src/api/common/polls/poll.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/common/video_quality.dart';
import 'package:mineral/src/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/src/infrastructure/internals/datastore/parts/channel_part.dart';

final class ChannelMethods {
  ChannelPart get dataStoreChannel => ioc.resolve<DataStoreContract>().channel;

  final Snowflake id;

  ChannelMethods(this.id);

  Future<void> setName(String name, String? reason) async {
    await dataStoreChannel.updateChannel(
      id: id,
      reason: reason,
      payload: {'name': name},
    );
  }

  Future<void> setDescription(String description, String? reason) async {
    await dataStoreChannel.updateChannel(
      id: id,
      reason: reason,
      payload: {'topic': description},
    );
  }

  Future<void> setCategory(String categoryId, String? reason) async {
    await dataStoreChannel.updateChannel(
      id: id,
      reason: reason,
      payload: {'parent_id': categoryId},
    );
  }

  Future<void> setPosition(int position, String? reason) async {
    await dataStoreChannel.updateChannel(
      id: id,
      reason: reason,
      payload: {'position': position},
    );
  }

  Future<void> setNsfw(bool nsfw, String? reason) async {
    await dataStoreChannel.updateChannel(
      id: id,
      reason: reason,
      payload: {'nsfw': nsfw},
    );
  }

  Future<void> setRateLimitPerUser(int rateLimitPerUser, String? reason) async {
    await dataStoreChannel.updateChannel(
      id: id,
      reason: reason,
      payload: {'rate_limit_per_user': rateLimitPerUser},
    );
  }

  Future<void> setDefaultAutoArchiveDuration(
      int defaultAutoArchiveDuration, String? reason) async {
    await dataStoreChannel.updateChannel(
      id: id,
      reason: reason,
      payload: {'default_auto_archive_duration': defaultAutoArchiveDuration},
    );
  }

  Future<void> setDefaultThreadRateLimitPerUser(
      int value, String? reason) async {
    await dataStoreChannel.updateChannel(
      id: id,
      reason: reason,
      payload: {'default_thread_rate_limit_per_user': value},
    );
  }

  Future<void> setBitrate(int bitrate, String? reason) async {
    await dataStoreChannel.updateChannel(
      id: id,
      reason: reason,
      payload: {'bitrate': bitrate},
    );
  }

  Future<void> setUserLimit(int userLimit, String? reason) async {
    await dataStoreChannel.updateChannel(
      id: id,
      reason: reason,
      payload: {'user_limit': userLimit},
    );
  }

  Future<void> setRtcRegion(String rtcRegion, String? reason) async {
    await dataStoreChannel.updateChannel(
      id: id,
      reason: reason,
      payload: {'rtc_region': rtcRegion},
    );
  }

  Future<void> setVideoQuality(VideoQuality quality, String? reason) async {
    await dataStoreChannel.updateChannel(
      id: id,
      reason: reason,
      payload: {'video_quality_mode': quality},
    );
  }

  Future<void> send(
      {Snowflake? guildId,
      String? content,
      List<MessageEmbed>? embeds,
      Poll? poll,
      List<MessageComponent>? components}) async {
    await dataStoreChannel.createMessage(
        guildId, id, content, embeds, poll, components);
  }

  Future<void> delete(String? reason) async {
    await dataStoreChannel.deleteChannel(id, reason);
  }
}
