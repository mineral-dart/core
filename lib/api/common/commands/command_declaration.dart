import 'package:mineral/api/common/commands/builder/command_declaration_builder.dart';
import 'package:mineral/api/common/commands/command_contract.dart';

abstract interface class CommandDeclaration implements CommandContract<CommandDeclarationBuilder>{
  @override
  CommandDeclarationBuilder build();
}
