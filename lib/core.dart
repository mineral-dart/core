/// 🧡 The neuralgic heart of the application, this module gathers all the functionalities of the framework.
library core;

export 'src/internal/services/environment.dart' show Environment;

export 'src/internal/kernel.dart' show Kernel;
export 'package:mineral_ioc/ioc.dart' show ioc, Service;

export 'src/constants.dart';
export 'src/internal/services/http.dart';
export 'src/internal/entities/event.dart' show Event, Events, MineralEvent;
export 'src/internal/entities/command.dart' show MineralCommand, CommandBuilder, Option, OptionType, OptionChoice, SubCommandBuilder, CommandGroupBuilder, Scope;
export 'src/internal/entities/store.dart' show Store, MineralStore;
export 'src/internal/entities/module.dart' show Module, MineralModule;
export 'src/internal/entities/context_menu.dart' show MessageMenuInteraction, MineralContextMenu;

