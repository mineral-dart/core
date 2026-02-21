import 'package:mineral/src/api/common/types/enhanced_enum.dart';

enum ComponentType implements EnhancedEnum<int> {
  actionRow(1),
  button(2),
  textSelectMenu(3),
  textInput(4),
  userSelectMenu(5),
  roleSelectMenu(6),
  mentionableSelectMenu(7),
  channelSelectMenu(8),
  section(9),
  textDisplay(10),
  thumbnail(11),
  mediaGallery(12),
  file(13),
  separator(14),
  container(17),
  label(18);

  static const selectMenus = [
    textSelectMenu,
    userSelectMenu,
    roleSelectMenu,
    mentionableSelectMenu,
    channelSelectMenu,
  ];

  @override
  final int value;

  const ComponentType(this.value);
}

abstract interface class Component {
  Map<String, dynamic> toJson();
}
