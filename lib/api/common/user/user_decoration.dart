import 'package:mineral/api/common/contracts/user_decoration_contract.dart';

final class UserDecoration implements UserDecorationContract {
  @override
  final String? avatar;

  @override
  final String? banner;

  @override
  final int? accentColor;

  UserDecoration({
    this.avatar,
    this.banner,
    this.accentColor,
  });
}