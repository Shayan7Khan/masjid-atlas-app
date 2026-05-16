import 'package:flutter_antonx_boilerplate/core/config/config.dart';
import 'package:flutter_antonx_boilerplate/core/enums/env.dart';
import 'package:flutter_antonx_boilerplate/core/repo/masjid_repository.dart';
import 'package:flutter_antonx_boilerplate/core/services/auth_service.dart';
import 'package:flutter_antonx_boilerplate/core/services/location_service.dart';
import 'package:flutter_antonx_boilerplate/core/services/masjid_api_service.dart';
import 'package:flutter_antonx_boilerplate/core/services/masjid_database_service.dart';
import 'package:flutter_antonx_boilerplate/core/utils.dart';
import 'package:get_it/get_it.dart';

import 'core/services/api_services.dart';

import 'core/services/mock_database_service.dart';
import 'core/services/file_picker_service.dart';
import 'core/services/notifications_service.dart';
import 'core/services/local_storage_service.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator(Env env) async {
  locator.registerSingleton(Config(env));

  final localStorage = LocalStorageService();
  await localStorage.init();

  locator.registerSingleton<LocalStorageService>(localStorage);

  locator.registerSingleton(NotificationsService());
  locator.registerSingleton<ApiServices>(ApiServices());
  locator.registerSingleton<MasjidApiService>(MasjidApiService());

  locator.registerSingleton<MasjidRepository>(MasjidRepository());
  locator.registerSingleton<MasjidDatabaseService>(MasjidDatabaseService());
  locator.registerSingleton<MockDatabaseService>(MockDatabaseService());

  locator.registerSingleton<AuthService>(AuthService());
  locator.registerSingleton<Utils>(Utils());
  locator.registerLazySingleton(() => FilePickerService());
  locator.registerLazySingleton(() => LocationService());
}
