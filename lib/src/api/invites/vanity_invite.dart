import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral_ioc/ioc.dart';

import '../../../core.dart';

class VanityInvite {
  final String? code;
  final int uses;

  VanityInvite({
    required this.code,
    required this.uses,
  });

  /// Syncs the vanity invite for the [Guild].
  /// ```dart
  /// VanityInvite? invite = await VanityInvite.sync(guild);
  /// ```
  ///
  static Future<VanityInvite?> sync(Snowflake guildId) async {
     Response response = await ioc.use<DiscordApiHttpService>().get(url: "/guilds/$guildId/vanity-url").build();

     if(response.statusCode != 200) {
       return null;
     }

    return VanityInvite.from(jsonDecode(response.body));
  }

  factory VanityInvite.from(Map<String, dynamic> payload) {
    return VanityInvite(
      code: payload['code'],
      uses: payload['uses'],
    );
  }
}