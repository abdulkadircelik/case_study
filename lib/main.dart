import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'core/theme/app_theme.dart';
import 'core/di/injection.dart';
import 'core/services/logger_service.dart';
import 'core/services/storage_service.dart';
import 'core/routes/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Crashlytics
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Initialize dependencies
  await configureDependencies();

  // Initialize storage service
  await getIt<StorageService>().initialize();

  // Initialize permissions
  await Permission.camera.status;
  await Permission.photos.status;

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('tr'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('tr'),
      useOnlyLangCode: true,
      startLocale: const Locale('tr'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final LoggerService _logger;

  @override
  void initState() {
    super.initState();
    _logger = getIt<LoggerService>();
    // _localizationService = getIt<LocalizationService>();

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      _logger.info('App initialized successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to initialize app', e, stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final authBloc = getIt<AuthBloc>();
        authBloc.add(CheckAuthStatus());
        return authBloc;
      },
      child: MaterialApp.router(
        title: 'Case Study',
        debugShowCheckedModeBanner: false,

        // Localization
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,

        // Theme
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark, // Default to dark theme
        // Router
        routerConfig: appRouter,

        // Firebase Analytics
        // navigatorObservers: [
        //   FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
        // ],
      ),
    );
  }
}
