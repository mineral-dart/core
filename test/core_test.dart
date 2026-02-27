import './internals/ioc.dart' as ioc_test;
import './internals/shard_disconnect_error_test.dart'
    as shard_disconnect_error_test;
import './enums/common_enums_test.dart' as common_enums_test;
import './enums/server_enums_test.dart' as server_enums_test;
import './enums/moderation_enums_test.dart' as moderation_enums_test;
import './enums/string_enums_test.dart' as string_enums_test;

void main() {
  ioc_test.main();
  shard_disconnect_error_test.main();
  common_enums_test.main();
  server_enums_test.main();
  moderation_enums_test.main();
  string_enums_test.main();
}
