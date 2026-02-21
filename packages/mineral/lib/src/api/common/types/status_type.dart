import 'package:mineral/src/api/common/types/enhanced_enum.dart';

enum StatusType implements EnhancedEnum<String> {
  online('online'),
  idle('idle'),
  doNotDerange('dnd'),
  offline('offline');

  @override
  final String value;
  const StatusType(this.value);
}
