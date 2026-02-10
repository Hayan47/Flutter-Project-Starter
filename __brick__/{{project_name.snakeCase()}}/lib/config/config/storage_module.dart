import 'package:injectable/injectable.dart';

import '../core/storage/hive_service.dart';
import '../core/storage/local_storage_service.dart';

@module
abstract class StorageModule {
  @preResolve
  @lazySingleton
  Future<LocalStorageService> localStorageService() async {
    final service = LocalStorageService();
    await service.init();
    return service;
  }

  @preResolve
  @lazySingleton
  Future<HiveService> hiveService() async {
    final service = HiveService();
    await service.init();
    return service;
  }
}