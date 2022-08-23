import 'package:mineral/api.dart';

class ChannelBuilder {
  Map<String, dynamic> payload;
  ChannelBuilder(this.payload);

  factory ChannelBuilder.fromTextChannel ({
    String? label,
    String? description,
    int? parentId,
    int? position,
    List<PermissionOverwrite>? permissions,
    bool? nsfw,
    int? rateLimitPerUser,
  }) {
    return ChannelBuilder({
      'name': label,
      'topic': description,
      'parent_id': parentId,
      'position': position,
      'permission_overwrites': permissions?.map((permission) => permission.toJSON()),
      'nsfw': nsfw,
      'rate_limit_per_user': rateLimitPerUser
    });
  }

  factory ChannelBuilder.fromCategoryChannel ({
    String? label,
    int? position,
    List<PermissionOverwrite>? permissions,
  }) {
    return ChannelBuilder({
      'name': label,
      'position': position,
      'permission_overwrites': permissions?.map((permission) => permission.toJSON()),
    });
  }
}
