import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:zeroed/core/services/connectivity_service.dart';
import 'package:zeroed/core/services/hive_service.dart';

part 'sync_service.g.dart';

/// Offline-first sync engine.
///
/// When the app comes back online, queued mutations are replayed
/// against Supabase in order. For now this is a placeholder that
/// will be fleshed out once repositories exist.
@Riverpod(keepAlive: true)
class SyncService extends _$SyncService {
  @override
  void build() {
    ref.listen(isOnlineProvider, (prev, next) {
      if (prev == false && next == true) {
        _flushQueue();
      }
    });
  }

  Future<void> _flushQueue() async {
    final hive = ref.read(hiveServiceProvider);
    final queue = hive.getAll(hive.syncQueueBox);
    if (queue.isEmpty) return;

    // TODO: replay queued mutations against Supabase
    // For each item: determine table, operation (insert/update/delete),
    // execute against Supabase, then remove from queue on success.
  }
}
