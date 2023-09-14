import '../channel.dart';

class GuildChannel extends Channel {
  final Null guild;
  Null categoryChannel;
  List<Null> permissions;
  int? flags;
  int? position;

  GuildChannel({required super.id, required super.label, required this.guild, required this.categoryChannel, required this.permissions, required this.flags, required this.position});

  /// Delete this channel
  /// ```dart
  /// await channel.delete();
  /// ```
  ///
  Future<void> delete() async {
    // todo
  }

  /// Edit this channel
  /// ```dart
  /// await channel.edit(label: 'new label', permissions: [PermissionsOverwrite(id: '', type: PermissionType.member, allow: true)]);
  /// ```
  Future<void> edit({ String? label, List<Null>? permissions }) async {
    // todo
  }
}