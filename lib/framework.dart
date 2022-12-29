/// Contains the main services of the mineral framework as well as helper extensions
library framework;

export '../src/internal/entities/command.dart' show MineralCommand, CommandBuilder, Option, OptionType, OptionChoice, SubCommandBuilder, CommandGroupBuilder, Scope;
export '../src/internal/entities/context_menu.dart' show MineralContextMenu;
export '../src/internal/entities/event.dart' show MineralEvent, Event;
export '../src/internal/entities/module.dart' show MineralModule;
export '../src/internal/entities/state.dart' show MineralState;
export '../src/internal/mixins/console.dart';
export 'src/internal/mixins/collection.dart';
export 'src/internal/mixins/string.dart';
