import 'dart:async';

final class Helper {
  static T? createOrNull<T>(
      {required dynamic field, required T? Function() fn}) {
    return field != null ? fn() : null;
  }

  static Future<T?> createOrNullAsync<T>(
          {required dynamic field, required Future<T?> Function() fn}) async =>
      field != null ? await fn() : null;
}
