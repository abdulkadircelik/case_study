import 'package:get_it/get_it.dart';
import '../services/logger_service.dart';
import '../services/navigation_service.dart';
import '../services/storage_service.dart';
// import '../services/localization_service.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Core Services
  getIt.registerSingleton<LoggerService>(LoggerService());
  getIt.registerSingleton<NavigationService>(NavigationService());
  getIt.registerSingleton<StorageService>(StorageService());
  // getIt.registerSingleton<LocalizationService>(
  //   LocalizationService(getIt<StorageService>()),
  // );
}
