import 'package:injectable/injectable.dart';

import '../core/network/api_client.dart';
import '../features/auth/data/datasources/remote/auth_remote_datasource.dart';
import '../features/branches/data/datasources/remote/branch_remote_datasource.dart';
import '../features/devices/data/datasources/remote/device_remote_datasource.dart';
import '../features/requests/data/datasources/remote/requests_remote_datasource.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  @Environment('dev')
  @Environment('prod')
  AuthRemoteDataSource authDataSource(ApiClient client) =>
      AuthRemoteDataSource(client.dio);

  @lazySingleton
  @Environment('dev')
  @Environment('prod')
  BranchRemoteDataSource branchDataSource(ApiClient client) =>
      BranchRemoteDataSource(client.dio);

  @lazySingleton
  @Environment('dev')
  @Environment('prod')
  DeviceRemoteDataSource deviceDataSource(ApiClient client) =>
      DeviceRemoteDataSource(client.dio);

  @lazySingleton
  @Environment('dev')
  @Environment('prod')
  RequestsRemoteDataSource requestsDataSource(ApiClient client) =>
      RequestsRemoteDataSource(client.dio);
}