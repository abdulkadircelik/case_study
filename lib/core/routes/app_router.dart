import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/upload_photo_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/firebase_test_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../di/injection.dart';
import '../services/navigation_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: getIt<NavigationService>().navigatorKey,
  initialLocation: '/',
  observers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
  routes: [
    GoRoute(
      path: '/',
      name: 'start',
      builder: (context, state) => const StartPage(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/upload-photo',
      name: 'upload-photo',
      builder: (context, state) => const UploadPhotoPage(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/firebase-test',
      name: 'firebase-test',
      builder: (context, state) => const FirebaseTestPage(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfilePage(),
    ),
  ],
  errorBuilder: (context, state) =>
      Scaffold(body: Center(child: Text('Sayfa bulunamadı: ${state.error}'))),
);

// StartPage widget'ını buraya taşıyalım
class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late final StorageService _storageService;

  @override
  void initState() {
    super.initState();
    _storageService = getIt<StorageService>();

    Future.delayed(const Duration(seconds: 2), () {
      initFunction();
    });
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
    try {
      // Token kontrolü yap
      final token = await _storageService.getToken();
      final userData = await _storageService.getUserData();

      // Widget hala mounted mı kontrol et
      if (!mounted) return;

      if (token != null && userData != null) {
        // Token varsa direkt home page'e git
        if (mounted) {
          context.go('/home');
        }
      } else {
        // Token yoksa login page'e git
        if (mounted) {
          context.go('/login');
        }
      }
    } catch (e) {
      // Widget hala mounted mı kontrol et
      if (!mounted) return;

      // Hata durumunda login page'e git
      if (mounted) {
        context.go('/login');
      }
    }
  }
}
