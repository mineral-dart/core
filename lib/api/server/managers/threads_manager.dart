import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/channels/thread_channel.dart';

final class ThreadsManager {
  final Map<Snowflake, ThreadChannel> _threads;

  ThreadsManager(this._threads);

  Map<Snowflake, ThreadChannel> get list => _threads;

  T? getOrNull<T extends ThreadChannel>(Snowflake? id) => _threads[id] as T?;

  T getOrFail<T extends ThreadChannel>(String id) =>
      _threads.values.firstWhere((element) => element.id.value == id,
          orElse: () => throw Exception('Channel not found')) as T;

  void add(ThreadChannel thread) {
    _threads[thread.id] = thread;
  }

  void remove(Snowflake id) {
    _threads.remove(id);
  }

  Future<ThreadChannel> create() async {
    throw UnimplementedError();
  }

  factory ThreadsManager.fromList(List<ThreadChannel> threads, payload) {
    return ThreadsManager(
        Map<Snowflake, ThreadChannel>.from(threads.fold({}, (value, element) {
          return {...value, element.id: element};
        })),
    );
  }
}
