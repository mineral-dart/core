```dart
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

@ContextMenu(name: 'user', type: ContextMenuType.user, scope: 'GUILD')
class UserContext extends MineralContextMenu {
  Future<void> handle (ContextUserInteraction interaction) async {
    await interaction.reply(content: interaction.target.toString(), private: true);
  }
}
```
