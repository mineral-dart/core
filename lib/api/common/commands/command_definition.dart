import 'package:mineral/api/common/commands/builder/command_definition_builder.dart';
import 'package:mineral/api/common/commands/command_contract.dart';

abstract interface class CommandDefinition implements CommandContract<CommandDefinitionBuilder>{
  @override
  CommandDefinitionBuilder build();
}
