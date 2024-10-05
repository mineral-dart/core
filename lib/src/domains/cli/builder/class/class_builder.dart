
import 'package:mineral/src/domains/cli/builder/class/method_struct.dart';
import 'package:mineral/src/domains/cli/builder/class/parameter_struct.dart';

final class ClassBuilder {
  final List<String> imports = [];
  final List<ParameterStruct> implements = [];
  final List<MethodStruct> methods = [];

  String? className;
  ParameterStruct? extension;

  ClassBuilder setClassName(String className) {
    this.className = className;
    return this;
  }

  ClassBuilder setExtends(ParameterStruct struct) {
    extension = struct;

    if (struct.import case final String value when !imports.contains(value)) {
      imports.add(value);
    }

    return this;
  }

  ClassBuilder addImplement(ParameterStruct struct) {
    implements.add(struct);

    if (struct.import case final String value when !imports.contains(value)) {
      imports.add(value);
    }

    return this;
  }

  ClassBuilder addMethod(MethodStruct method) {
    methods.add(method);

    final imports = [method.returnType.import, ...method.parameters.map((parameter) => parameter.import)];
    for (final import in imports) {
      if (import case final String value when !this.imports.contains(value)) {
        this.imports.add(value);
      }
    }

    return this;
  }

  String build() {
    final buffer = StringBuffer();

    for (final import in imports) {
      buffer.write("import '$import';");
    }

    buffer.write('final class $className');

    if (extension case ParameterStruct(:final name)) {
      buffer.write(' extends $name');
    }

    if (implements.isNotEmpty) {
      buffer
        ..write(' implements ')
        ..write(implements.fold('', (acc, implement) => '$acc${implement.name}, '));
    }

    buffer.write(' {');

    for (final method in methods) {
      if (method.isOverride) {
        buffer.writeln('@override');
      }

      buffer.write('${method.returnType.name} ${method.name}(');

      final parameters = method.parameters.map((parameter) => parameter.name);
      buffer
        ..write(parameters.join(', '))
        ..write(')');

      if (method.isAsync) {
        buffer.write(' async');
      }

      buffer
        ..write(' {')
        ..writeln(method.body.toString())
        ..write('  }');
    }

    buffer.write('}');

    return buffer.toString();
  }
}
