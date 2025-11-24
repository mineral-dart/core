import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';

final class Emoji extends PartialEmoji {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  final Snowflake serverId;
  final Map<Snowflake, Role> roles;
  final bool isManaged;
  final bool isAvailable;

  Emoji(
    this.serverId, {
    required Snowflake id,
    required String name,
    required this.roles,
    required this.isManaged,
    required this.isAvailable,
    required bool isAnimated,
  }) : super(id, name, isAnimated);

  /// Update image
  /// ```dart
  /// await emoji.setImage(Image.fromFile('path/to/file.png'));
  /// ```
  Future<void> setImage(Image image, {String? reason}) async {
    await _datastore.emoji.update(
      id: id!.value,
      serverId: serverId.value,
      reason: reason,
      payload: {'image': image.base64},
    );
  }

  /// Update name
  /// ```dart
  /// await emoji.setName('New Emoji Name');
  /// ```
  Future<void> setName(String name, {String? reason}) async {
    await _datastore.emoji.update(
      id: id!.value,
      serverId: serverId.value,
      reason: reason,
      payload: {'name': name.replaceAll(' ', '_')},
    );
  }

  /// Update roles
  /// ```dart
  /// await emoji.setRole(['1091121140090535956']);
  /// ```
  Future<void> setRoles(List<Snowflake> roles, {String? reason}) async {
    await _datastore.emoji.update(
      id: id!.value,
      serverId: serverId.value,
      reason: reason,
      payload: {'roles': roles.map((element) => element.value).toList()},
    );
  }

  /// Add role
  /// ```dart
  /// await emoji.addRole('1091121140090535956');
  /// ```
  Future<void> addRole(Snowflake role, {String? reason}) async {
    await _datastore.emoji.update(
      id: id!.value,
      serverId: serverId.value,
      reason: reason,
      payload: {'roles': [...roles.keys.map((e) => e.value), role.value]},
    );
  }

  /// Remove role
  /// ```dart
  /// await emoji.removeRole('1091121140090535956');
  /// ```
  Future<void> removeRole(Snowflake role, {String? reason}) async {
    await _datastore.emoji.update(
      id: id!.value,
      serverId: serverId.value,
      reason: reason,
      payload: {'roles': roles.keys.map((e) => e.value).where((e) => e != role.value).toList()},
    );
  }

  /// Update an emoji.
  /// ```dart
  /// await emoji.update(name: 'New Emoji Name');
  /// ```
  Future<void> update(
      {String? name, Image? image, List<Snowflake> roles = const [], String? reason}) async {
    await _datastore.emoji.update(
      id: id!.value,
      serverId: serverId.value,
      reason: reason,
      payload: {
        if (name != null) 'name': name.replaceAll(' ', '_'),
        if (image != null) 'image': image.base64,
        if (roles.isNotEmpty) 'roles': roles,
      },
    );
  }

  /// Delete an emoji.
  /// ```dart
  /// await emoji.delete();
  /// ```
  Future<void> delete({String? reason}) {
    return switch (id) {
      Snowflake(:final value) => _datastore.emoji.delete(serverId.value, value, reason: reason),
      _ => throw Exception('Unknown emoji id: $id'),
    };
  }
}
