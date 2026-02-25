import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';
import 'routes.dart';
import 'theme/app_theme.dart';
import 'providers/theme_provider.dart';

import 'pages/splash_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/home_page2.dart';
import 'pages/home_page_splash.dart';
import 'pages/home_page_main.dart';

import 'models/habit.dart'; // <- wajib import Habit

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive
  await Hive.initFlutter();
  //{Inline Review: Tambahkan guard adapter registration untuk mencegah duplicate registration error.}
  Hive.registerAdapter(HabitAdapter()); // daftar adapter Habit
  await Hive.openBox<Habit>('habitsBox'); // nama box konsisten dengan app

  runApp(const ProviderScope(child: HabitlyApp()));
}

class HabitlyApp extends ConsumerWidget {
  const HabitlyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(themeProvider); // state dark/light mode

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habitly',

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: currentMode,

      // Halaman awal
      initialRoute: AppRoutes.loginsplash,

      routes: {
        AppRoutes.loginsplash: (context) => const SplashPage(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.register: (context) => const RegisterPage(),
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.homePage2: (context) => const HomePage2(),
        AppRoutes.homeSplashPage: (context) => const HomeSplashPage(),
        AppRoutes.homePageMain: (context) => const HomePageMain(),
      },
    );
  }
}
