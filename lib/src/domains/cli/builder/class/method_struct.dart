import 'package:mineral/src/domains/cli/builder/class/parameter_struct.dart';

final class MethodStruct {
  final String name;
  final ParameterStruct returnType;
  final StringBuffer body;
  final List<ParameterStruct> parameters;
  final bool isOverride;
  final bool isAsync;

  MethodStruct({
    required this.name,
    required this.returnType,
    required this.parameters,
    required this.body,
    required this.isOverride,
    required this.isAsync,
  });
}
