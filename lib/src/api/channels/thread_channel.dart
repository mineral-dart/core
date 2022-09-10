import 'package:mineral/api.dart';
import 'package:mineral/src/api/managers/message_manager.dart';
import 'package:mineral/src/api/managers/permission_overwrite_manager.dart';

class ThreadChannel extends PartialTextChannel {
  final bool _archived;
  final int _autoArchiveDuration;
  final bool _locked;
  final bool? _invitable;
  final String _createdAt;

  ThreadChannel(
    this._archived,
    this._autoArchiveDuration,
    this._locked,
    this._invitable,
    this._createdAt,
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

  /// Check if this is archived
  bool get isArchived => _archived;

  /// [Duration] of live of this
  AutoArchiveDuration get autoArchiveDuration => AutoArchiveDuration.values.firstWhere((element) => element.value == _autoArchiveDuration);

  /// This is locked
  bool get isLocked => _locked;

  /// Check if member is allow to add another member
  bool? get isInvitable => _invitable;

  /// Get birthday of this
  DateTime get createdAt => DateTime.parse(_createdAt);

  /// Get parent of this
  @override
  TextChannel get parent => super.parent as TextChannel;

  factory ThreadChannel.fromPayload(dynamic payload) {
    final permissionOverwriteManager = PermissionOverwriteManager();
    for (final element in payload['permission_overwrites']) {
      final PermissionOverwrite overwrite = PermissionOverwrite.from(payload: element);
      permissionOverwriteManager.cache.putIfAbsent(overwrite.id, () => overwrite);
    }

    return ThreadChannel(
      payload['thread_metadata']['archived'],
      payload['thread_metadata']['auto_archive_duration'],
      payload['thread_metadata']['locked'],
      payload['thread_metadata']['invitable'],
      payload['create_timestamp'],
      MessageManager(),
      payload['last_message_id'],
      payload['guild_id'],
      payload['parent_id'],
      payload['name'],
      payload['type'],
      payload['position'],
      payload['flags'],
      permissionOverwriteManager,
      payload['id']
    );
  }
}

enum AutoArchiveDuration {
  hour(60),
  day(1440),
  threeDays(4320),
  week(10080);

  final int value;
  const AutoArchiveDuration(this.value);
}
