import 'dart:io';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/sync_status.dart';

class BusinessRepository {
  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  BusinessRepository(this._db);

  /// Streams the active business profile.
  Stream<BusinessProfile?> watchCurrentProfile() {
    return (_db.select(_db.businessProfiles)
          ..where((tbl) => tbl.isCurrent.equals(true))
          ..limit(1))
        .watchSingleOrNull();
  }

  /// Gets the active business profile once.
  Future<BusinessProfile?> getCurrentProfile() async {
    return (_db.select(_db.businessProfiles)
          ..where((tbl) => tbl.isCurrent.equals(true))
          ..limit(1))
        .getSingleOrNull();
  }

  /// Saves or updates the current business profile.
  Future<BusinessProfile> saveBusinessProfile({
    required String businessName,
    required String panVatNumber,
    required String contactNumber,
    String? shopAddress,
    String? logoPath,
  }) async {
    final now = DateTime.now();
    final existing = await getCurrentProfile();

    if (existing != null) {
      final updated = existing.copyWith(
        businessName: businessName,
        panVatNumber: panVatNumber,
        contactNumber: contactNumber,
        shopAddress: Value(shopAddress),
        logoPath: Value(logoPath),
        updatedAt: now,
        syncStatus: SyncStatus.pending,
      );
      await _db.update(_db.businessProfiles).replace(updated);
      return updated;
    } else {
      final newProfile = BusinessProfilesCompanion.insert(
        id: _uuid.v4(),
        businessName: businessName,
        panVatNumber: panVatNumber,
        contactNumber: contactNumber,
        shopAddress: Value(shopAddress),
        logoPath: Value(logoPath),
        isCurrent: const Value(true),
        createdAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatus.pending),
      );
      await _db.into(_db.businessProfiles).insert(newProfile);
      return (await getCurrentProfile())!;
    }
  }

  /// Copies an image file selected by the user to the app's persistent documents directory.
  Future<String> persistLogoFile(String sourceFilePath) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final logoDir = Directory(p.join(docsDir.path, 'SajiloBilling', 'logos'));
    if (!await logoDir.exists()) {
      await logoDir.create(recursive: true);
    }
    final extension = p.extension(sourceFilePath);
    final targetPath = p.join(
      logoDir.path,
      'shop_logo_${DateTime.now().millisecondsSinceEpoch}$extension',
    );
    final sourceFile = File(sourceFilePath);
    await sourceFile.copy(targetPath);
    return targetPath;
  }
}
