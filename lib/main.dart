import 'package:flutter/material.dart';
import 'package:mission_5_habbits/pages/add_habit.dart';
import 'routes.dart';
import 'pages/splash_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/home_page2.dart';
import 'pages/home_page_splash.dart';
import 'pages/home_page_main.dart';

// Buat ValueNotifier global untuk theme
ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const HabitlyApp());
}

class HabitlyApp extends StatelessWidget {
  const HabitlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Habitly',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: currentMode, // <-- ini akan rebuild saat berubah
          initialRoute: AppRoutes.loginsplash,
          routes: {
            AppRoutes.loginsplash: (context) => const SplashPage(),
            AppRoutes.login: (context) => const LoginPage(),
            AppRoutes.register: (context) => const RegisterPage(),
            AppRoutes.home: (context) => const HomePage(),
            AppRoutes.homePage2: (context) => const HomePage2(),
            AppRoutes.homeSplashPage: (context) => const HomeSplashPage(),
            AppRoutes.homePageMain: (context) => const HomePageMain(),
            AppRoutes.addHabitPage: (context) => const AddHabitPage(),
          },
        );
      },
    );
  }
}