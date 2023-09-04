import 'dart:convert';

import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/src/api/builders/channel_builder.dart';
import 'package:mineral/src/api/managers/webhook_manager.dart';
import 'package:mineral_ioc/ioc.dart';

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

  /// Allow or disallow nsfw of this
  Future<void> setNsfw(bool value) async {
    await update(ChannelBuilder({ 'nsfw': value}));
  }

  /// Create an [Invite] for this
  /// ```dart
  /// final Invite invite = await channel.createInvite();
  /// print(invite.url);
  /// ```
  /// Channel should be an instance of [TextBasedChannel]
  Future<Invite> createInvite() async {
    final result = await ioc.use<DiscordApiHttpService>()
      .post(url: '/channels/$id/invites')
      .build();

    return Invite.from(guild.id, jsonDecode(result.body));
  }
}
