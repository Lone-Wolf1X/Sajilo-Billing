import 'package:path_provider/path_provider.dart';
import 'app_storage_locations.dart';

AppStorageLocations getAppStorageLocationsInstance() => AppStorageLocationsIo();

class AppStorageLocationsIo implements AppStorageLocations {
  @override
  Future<String> getDatabaseDirectoryPath() async {
    final docs = await getApplicationDocumentsDirectory();
    return docs.path;
  }

  @override
  Future<String?> getDownloadsDirectoryPath() async {
    final downloads = await getDownloadsDirectory();
    return downloads?.path;
  }
}
