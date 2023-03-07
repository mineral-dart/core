import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral_ioc/ioc.dart';

class DmUser extends User {
  final Snowflake _channelId;

  DmUser(
    super._id,
    super._username,
    super._discriminator,
    super._bot,
    super._publicFlags,
    super._avatar,
    super._avatarDecoration,
    super._lang,
    super.premiumType,
    this._channelId
  );

  Future<void> remove () async {
    await ioc.use<DiscordApiHttpService>()
      .destroy(url: '/channels/$_channelId/recipients/$id')
      .build();
  }

  factory DmUser.fromUser (User user, Snowflake channelId) {
    return DmUser(
      user.id,
      user.username,
      user.discriminator,
      user.bot,
      user.publicFlags,
      user.avatar,
      user.avatarDecoration,
      user.lang.locale,
      user.premiumType,
      channelId,
    );
  }
}