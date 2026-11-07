import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../data/business_repository.dart';

final businessRepositoryProvider = Provider<BusinessRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return BusinessRepository(db);
});

/// Watches the active business profile from SQLite.
final businessProfileStreamProvider = StreamProvider<BusinessProfile?>((ref) {
  final repo = ref.watch(businessRepositoryProvider);
  return repo.watchCurrentProfile();
});

/// Determines if the user has completed onboarding (business info saved).
final isBusinessConfiguredProvider = Provider<bool>((ref) {
  final profileAsync = ref.watch(businessProfileStreamProvider);
  return profileAsync.maybeWhen(
    data: (profile) => profile != null,
    orElse: () => false,
  );
});

