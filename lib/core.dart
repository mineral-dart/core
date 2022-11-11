/// 🧡 The neuralgic heart of the application, this module gathers all the functionalities of the framework.
library core;

export 'package:mineral_ioc/ioc.dart' show ioc, Service;

export 'src/constants.dart';
export 'src/internal/entities/command.dart' show MineralCommand, CommandBuilder, Option, OptionType, OptionChoice, SubCommandBuilder, CommandGroupBuilder, Scope;
export 'src/internal/entities/context_menu.dart' show MineralContextMenu;
export 'src/internal/entities/event.dart' show Event, Events, MineralEvent;
export 'src/internal/entities/module.dart' show MineralModule;
export 'src/internal/entities/state.dart' show MineralState;
export 'src/internal/kernel.dart' show Kernel;
export 'src/internal/services/environment.dart' show Environment;
export 'src/internal/services/http.dart';

