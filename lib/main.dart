import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodlink_admin_panel/providers/beyond_calories_articles_provider.dart';
import 'package:foodlink_admin_panel/screens/auth_screens/login_screen.dart';
import 'package:foodlink_admin_panel/screens/auth_screens/sign_up_screen.dart';
import 'package:foodlink_admin_panel/screens/dashboard/dashboard.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'core/constants/colors.dart';
import 'providers/authentication_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/general_provider.dart';
import 'providers/meal_categories_provider.dart';
import 'providers/meals_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/admins_provider.dart';
import 'services/translation_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyB2-BqoayC6CbRZMKoK-bP8XZhYJZGRFO8",
    appId: "1:474506091113:web:e4ee7fdbff4369e28f60f8",
    storageBucket: "foodlink-6c41e.appspot.com",
    messagingSenderId: "474506091113",
    projectId: "foodlink-6c41e",
  ));

  FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (ctx) => GeneralProvider()),
    ChangeNotifierProvider(create: (ctx) => AuthProvider()),
    ChangeNotifierProvider(create: (ctx) => AdminsProvider()),
    ChangeNotifierProvider(create: (ctx) => MealCategoriesProvider()),
    ChangeNotifierProvider(create: (ctx) => DashboardProvider()),
    ChangeNotifierProvider(create: (ctx) => MealsProvider()),
    ChangeNotifierProvider(create: (ctx) => SettingsProvider()),
    ChangeNotifierProvider(create: (ctx) => BeyondCaloriesArticlesProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTranslations();
  }

  Future<void> _loadTranslations() async {
    await TranslationService().loadTranslations(context);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primaryColor;
            }
            return AppColors.backgroundColor;
          }),
          checkColor: WidgetStateProperty.all(AppColors.backgroundColor),
        ),
      ),
      initialRoute: '/signup', // Initial route
      getPages: [
        GetPage(
          name: '/signup',
          page: () => const SignUpScreen(),
        ),
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
        ),
        GetPage(
          name: '/dashboard',
          page: () => const Dashboard(),
        ),
      ],
    );
  }
}
