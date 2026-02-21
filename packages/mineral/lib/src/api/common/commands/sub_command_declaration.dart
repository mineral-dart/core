import 'package:mineral/src/api/common/commands/builder/sub_command_builder.dart';
import 'package:mineral/src/domains/common/utils/listenable.dart';

abstract interface class SubCommandDeclaration implements Listenable {
  SubCommandBuilder build();
}
