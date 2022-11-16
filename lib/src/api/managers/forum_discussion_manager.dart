import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/src/api/channels/guild_channel.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/internal/mixins/container.dart';

class ForumDiscussionManager extends CacheManager<ThreadChannel> with Container {
  final Snowflake _channelId;

  ForumDiscussionManager(this._channelId);

  /// Create a new discussion within a forum.
  /// Warning guild requires [GuildFeature.community] feature
  /// ```
  Future<ThreadChannel?> create (String label, MessageBuilder message, { int? archiveDuration, int? rateLimit, List<Snowflake>? tags, bool? pin }) async {
    Response response = await container.use<Http>().post(url: '/channels/$_channelId/threads', payload: {
      'name': label,
      'auto_archive_duration': archiveDuration,
      'rate_limit_per_user': rateLimit,
      'applied_tags': tags,
      'message': message.toJson(),
      'flags': Flag.pinned.value,
    });

    return ThreadChannel.fromPayload(jsonDecode(response.body));
  }
}
