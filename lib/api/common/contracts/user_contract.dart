import 'package:mineral/api/common/contracts/user_decoration_contract.dart';
import 'package:mineral/api/common/snowflake.dart';

abstract interface class UserContract {
  abstract final Snowflake id;
  abstract final String username;
  abstract final String? globalName;
  abstract final String? discriminator;
  abstract final UserDecorationContract decoration;
  abstract final bool isBot;
  abstract final bool isSystem;
  abstract final bool isVerified;
  abstract final int publicFlags;
  abstract final int flags;
  abstract final String? locale;
}