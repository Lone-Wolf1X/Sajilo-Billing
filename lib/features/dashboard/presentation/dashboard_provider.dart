import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../backup/presentation/backup_provider.dart';
import '../data/dashboard_repository.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final backupService = ref.watch(backupServiceProvider);
  return DashboardRepository(db, backupService);
});

final dashboardMetricsProvider = FutureProvider<DashboardMetrics>((ref) {
  final repo = ref.watch(dashboardRepositoryProvider);
  return repo.getDashboardMetrics();
});
