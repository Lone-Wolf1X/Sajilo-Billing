import 'app_storage_locations.dart';

AppStorageLocations getAppStorageLocationsInstance() => AppStorageLocationsWeb();

class AppStorageLocationsWeb implements AppStorageLocations {
  @override
  Future<String> getDatabaseDirectoryPath() async {
    return '/sajilo_billing_virtual';
  }

  @override
  Future<String?> getDownloadsDirectoryPath() async {
    return null;
  }
}

