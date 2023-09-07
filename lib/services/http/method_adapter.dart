import 'package:mineral/internal/either.dart';

abstract class MethodAdapter {
  Future<EitherContract> build ();
}