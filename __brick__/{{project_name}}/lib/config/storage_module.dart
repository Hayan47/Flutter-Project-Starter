import 'package:injectable/injectable.dart';

import '../core/storage/hive_service.dart';
import '../core/storage/local_storage_service.dart';
{{#use_jwt_auth}}
import '../core/storage/secure_storage_service.dart';
{{/use_jwt_auth}}

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

{{#use_jwt_auth}}
  @preResolve
  @lazySingleton
  Future<SecureStorageService> secureStorageService() async {
    final service = SecureStorageService();
    await service.init();
    return service;
  }
{{/use_jwt_auth}}  
}