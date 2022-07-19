import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/helper.dart';
import 'package:mineral/src/exceptions/api_error.dart';

enum PermissionOverwriteType {
  role(0),
  member(1);

  final int value;
  const PermissionOverwriteType(this.value);
}

class PermissionOverwrite {
  Snowflake id;
  PermissionOverwriteType type;
  List<Permission> allow;
  List<Permission> deny;

  PermissionOverwrite({
    required this.id,
    required this.type,
    required this.allow,
    required this.deny
  });
  
  dynamic toJSON() {
    return {
      'id': id,
      'type': type.value,
      'allow': Helper.reduceRolePermissions(allow).toString(),
      'deny': Helper.reduceRolePermissions(deny).toString()
    };
  }

  /* /// ### Edit [PermissionOverwrite] of a [Channel]
  ///
  /// Example :
  /// ```dart
  /// final TextChannel channel = guild.channels.cache.get('240561194958716924');
  /// final PermissionOverwrite overwrite = await channel.permissionOverwrites.cache.getOrFail('240561194958716928');
  ///
  /// await overwrite.edit(allow: [Permission.sendMessages], deny: [Permission.banMembers, Permission.attachFiles]);
  /// ```*/
 /* Future<void> edit ({List<Permission>? allow, List<Permission>? deny}) async {
    final Http http = ioc.singleton(ioc.services.http);

    final Response response = await http.put(url: "/channels/$channelId/permissions/$id", payload: {
      'type': type.value,
      'allow': allow != null ? Helper.reduceRolePermissions(allow) : null,
      'deny': deny != null ? Helper.reduceRolePermissions(deny) : null
    });

    print(response.body);
    if(response.statusCode != 204) {
      throw ApiError(prefix: 'channel overwrite', cause: 'You can\'t edit the permissions of this channel!');
    }
  }*/

  factory PermissionOverwrite.from({required dynamic payload}) {
    return PermissionOverwrite(
      id: payload['id'],
      type: payload['type'] is String
        ? PermissionOverwriteType.values.firstWhere((element) => element.name == payload['type'])
        : PermissionOverwriteType.values.firstWhere((element) => element.value == payload['type']),
      allow: Helper.bitfieldToPermissions(payload['allow']),
      deny: Helper.bitfieldToPermissions(payload['deny']),
    );
  }
}