import 'package:mineral/src/api/common/commands/builder/command_definition_builder.dart';
import 'package:mineral/src/api/common/commands/command_contract.dart';
import 'package:mineral/src/infrastructure/commons/listenable.dart';

abstract interface class CommandDefinition
    implements CommandContract<CommandDefinitionBuilder>, Listenable{
  @override
  CommandDefinitionBuilder build();
}
