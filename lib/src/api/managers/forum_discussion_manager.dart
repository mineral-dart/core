import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/src/api/channels/thread_channel.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

import 'package:mineral/core.dart';

class ForumDiscussionManager extends CacheManager<ThreadChannel> {
  final Snowflake _channelId;

  ForumDiscussionManager(this._channelId);

  Future<ThreadChannel?> create (String label, MessageBuilder message, { int? archiveDuration, int? rateLimit, List<Snowflake>? tags }) async {
    Http http = ioc.singleton(Service.http);

    Response response = await http.post(url: '/channels/$_channelId/threads', payload: {
      'name': label,
      'auto_archive_duration': archiveDuration,
      'rate_limit_per_user': rateLimit,
      'applied_tags': tags,
      'message': message.toJson()
    });

    return ThreadChannel.fromPayload(jsonDecode(response.body));
  }
}
