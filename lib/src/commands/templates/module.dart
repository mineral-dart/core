final template = '''import 'package:mineral/framework.dart';

class &ClassName extends MineralModule {
  &ClassName (): super('&ClassNameSnakeCase', '&FilenameCapitalCase', '&FilenameCapitalCase description');
  
  @override
  Future<void> init () async {
    commands.register([]);
    events.register([]);
    contextMenus.register([]);
    states.register([]);
  }
}''';