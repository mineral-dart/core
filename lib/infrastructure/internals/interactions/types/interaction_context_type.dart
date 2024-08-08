import 'package:mineral/api/common/types/enhanced_enum.dart';

enum InteractionContextType implements EnhancedEnum<int> {
  server(0),
  botPrivate(1),
  privateChannel(2);

  @override
  final int value;

  const InteractionContextType(this.value);
}
