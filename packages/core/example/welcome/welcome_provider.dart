import 'package:mineral/api.dart';

import 'member_join.dart';
import 'ready.dart';

final class WelcomeProvider extends Provider {
  final Client _client;

  WelcomeProvider(this._client) {
    _client
      ..register<Ready>(Ready.new)
      ..register<MemberJoin>(MemberJoin.new);
  }
}
