import 'app_storage_locations_io.dart'
    if (dart.library.html) 'app_storage_locations_web.dart' as impl;

/// Cross-platform file/directory resolution abstraction.
abstract class AppStorageLocations {
  Future<String> getDatabaseDirectoryPath();
  Future<String?> getDownloadsDirectoryPath();

  static AppStorageLocations get instance => impl.getAppStorageLocationsInstance();
}

