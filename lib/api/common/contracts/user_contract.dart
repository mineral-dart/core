import 'package:mineral/api/common/contracts/user_decoration_contract.dart';

abstract interface class UserContract {
  abstract final String username;
  abstract final String? globalName;
  abstract final String? discriminator;
  abstract final UserDecorationContract decoration;
  abstract final bool isBot;
  abstract final bool isSystem;
  abstract final bool isVerified;
  abstract final List<dynamic> publicFlags;
  abstract final List<dynamic> flags;
  abstract final String? locale;
}