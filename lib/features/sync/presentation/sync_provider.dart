import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../backup/data/backup_service_locator.dart';
import '../data/sync_engine.dart';
import '../domain/sync_state_model.dart';

final syncEngineProvider = Provider<SyncEngine>((ref) {
  final db = ref.watch(databaseProvider);
  final auth = ref.watch(googleAuthServiceProvider);
  final engine = SyncEngine(db: db, auth: auth);
  ref.onDispose(() => engine.dispose());
  return engine;
});

final syncStateProvider = StreamProvider<SyncStateModel>((ref) {
  final engine = ref.watch(syncEngineProvider);
  return engine.stateStream;
});

