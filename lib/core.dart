/// 🧡 The neuralgic heart of the application, this module gathers all the functionalities of the framework.
library core;

export 'src/internal/environment.dart' show Environment;

export 'src/internal/kernel.dart' show Kernel;
export 'src/internal/ioc.dart' show ioc, Service;

export 'src/constants.dart';
export 'src/internal/http.dart';
export 'src/internal/managers/event_manager.dart' show Event, Events, MineralEvent;
export 'src/internal/managers/command_manager.dart' show Command, MineralCommand, Option, OptionType, OptionChoice, Subcommand, CommandGroup;
export 'src/internal/managers/store_manager.dart' show Store, MineralStore;
export 'src/internal/managers/module_manager.dart' show Module, MineralModule;
