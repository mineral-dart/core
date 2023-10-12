import 'package:mineral/api/common/contracts/application_contract.dart';
import 'package:mineral/api/common/snowflake.dart';

final class Application implements ApplicationContract {
  @override
  final Snowflake id;

  @override
  final int flags;

  Application({
    required this.id,
    required this.flags,
  });
}