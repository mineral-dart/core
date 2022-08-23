import 'package:mineral/api.dart';
import 'package:mineral/src/api/managers/thread_manager.dart';
import 'package:mineral/src/api/managers/webhook_manager.dart';

class TextBasedChannel extends PartialTextChannel {
  final bool _nsfw;
  final WebhookManager _webhooks;

  TextBasedChannel(
    this._nsfw,
    this._webhooks,
    super.messages,
    super.lastMessageId,
    super.guildId,
    super.parentId,
    super.label,
    super.type,
    super.position,
    super.flags,
    super.permissions,
    super.id
  );

  /// Is channel allow nsfw
  bool get isNsfw => _nsfw;

  /// Access to [WebhookManager]
  WebhookManager get webhooks => _webhooks;
}
