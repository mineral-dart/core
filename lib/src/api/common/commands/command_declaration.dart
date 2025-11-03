import 'package:mineral/src/api/common/commands/builder/command_declaration_builder.dart';
import 'package:mineral/src/api/common/commands/command_contract.dart';
import 'package:mineral/src/domains/common/utils/listenable.dart';

abstract interface class CommandDeclaration
    implements CommandContract<CommandDeclarationBuilder>, Listenable {
  @override
  CommandDeclarationBuilder build();
}
