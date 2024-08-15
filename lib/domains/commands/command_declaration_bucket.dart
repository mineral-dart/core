import 'package:mineral/api/common/commands/builder/command_declaration_builder.dart';
import 'package:mineral/api/common/commands/builder/command_definition_builder.dart';
import 'package:mineral/domains/commands/command_context.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';

final class CommandBucket {
  final KernelContract _kernel;

  CommandBucket(this._kernel);

  void declare(Function(CommandDeclarationBuilder) fn) {
    final builder = CommandDeclarationBuilder();
    fn(builder);

    _kernel.commands.addCommand(builder);
  }

  void define<T extends CommandContext>(Function(CommandDefinitionBuilder) fn) {
    final builder = CommandDefinitionBuilder();
    fn(builder);

    _kernel.commands.addCommand(builder.command);
  }
}
