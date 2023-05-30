import 'dart:convert';

import 'package:mineral/core/api.dart';
import 'package:mineral_ioc/ioc.dart';

import 'package:http/http.dart';
import '../../../core.dart';
import '../../internal/services/console/console_service.dart';

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
    /*if(!guild.features.contains(GuildFeature.vanityUrl)) {
      ioc.use<ConsoleService>().warn("The guild $guildId does not have a vanity invite.");
      return null;
    }*/

    Response response = await ioc.use<DiscordApiHttpService>().get(url: "/guilds/$guildId/vanity-url").build();
    print(response.body);
    print("dd");
    if(response.statusCode != 200) {
      ioc.use<ConsoleService>().warn("The guild $guildId does not have a vanity invite.");
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