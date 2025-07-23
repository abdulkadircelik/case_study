import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'core/theme/app_theme.dart';
import 'core/di/injection.dart';
import 'core/services/logger_service.dart';
import 'core/services/storage_service.dart';
import 'features/auth/presentation/pages/login_page.dart';

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
  // late final LocalizationService _localizationService;
  late final StorageService _storageService;

  @override
  void initState() {
    super.initState();
    _logger = getIt<LoggerService>();
    // _localizationService = getIt<LocalizationService>();
    _storageService = getIt<StorageService>();

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
    return MultiProvider(
      providers: [
        Provider<LoggerService>.value(value: _logger),
        // Provider<LocalizationService>.value(value: _localizationService),
        Provider<StorageService>.value(value: _storageService),
      ],
      child: MaterialApp(
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
        // Navigation
        home: const StartPage(),

        // Firebase Analytics
        // navigatorObservers: [
        //   FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
        // ],
      ),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      initFunction();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/SinFlixSplash.png'),
          ),
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  void initFunction() async {
    // Onboarding'i test etmek için önce onboarding'e git
    // Get.offAllNamed(RoutesClass.onboardingScreen);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
