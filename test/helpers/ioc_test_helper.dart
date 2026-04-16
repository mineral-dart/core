import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';

import 'fake_logger.dart';

/// Creates a scoped IoC container for testing with a FakeLogger bound.
/// Returns a restore function to call in tearDown.
({IocContainer container, FakeLogger logger, void Function() restore})
    createTestIoc() {
  final logger = FakeLogger();
  final container = IocContainer()..bind<LoggerContract>(() => logger);
  final restore = scopedIoc(container);
  return (container: container, logger: logger, restore: restore);
}
