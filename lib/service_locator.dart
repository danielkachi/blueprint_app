import 'package:blueprint_app2/services/blueprint_api_service.dart';
import 'package:blueprint_app2/services/navigation_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.I;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => ApiService());
}
