import 'package:mineral/api/api/server/guild.dart';

final class GuildMember {
  final String id;
  final String username;
  final String discriminator;
  final String? avatar;
  final bool? bot;
  final bool? system;
  final bool? mfaEnabled;
  final String? locale;
  final bool? verified;
  final String? email;
  final int? flags;
  final int? premiumType;
  final int? publicFlags;
  final String guildId;
  final Guild guild;

  GuildMember({
    required this.id,
    required this.username,
    required this.discriminator,
    required this.avatar,
    required this.bot,
    required this.system,
    required this.mfaEnabled,
    required this.locale,
    required this.verified,
    required this.email,
    required this.flags,
    required this.premiumType,
    required this.publicFlags,
    required this.guildId,
    required this.guild,
  });
}
