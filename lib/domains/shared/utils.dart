T? createOrNull<T>({ required dynamic field, required T? Function() fn }) => field != null ? fn() : null;
