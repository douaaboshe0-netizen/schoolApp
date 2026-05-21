import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/theme_controller.dart';
import 'routes/app_pages.dart';

// ← هذا الجزء هو المهم جداً (إضافة جديدة)
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ← هذا السطر هو اللي بيخلي Flutter يقبل شهادة runasp.net
  HttpOverrides.global = MyHttpOverrides();

  Get.put(ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (controller) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'school_app',

        themeMode: controller.theme,

        // 🌞 الوضع النهاري
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 19, 150, 19),
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          cardColor: Colors.white,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.black),
            bodyMedium: TextStyle(color: Colors.black87),
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, 19, 150, 19),
            brightness: Brightness.light,
          ),
        ),

        // 🌙 الوضع الليلي
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF121212),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E1E1E),
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          cardColor: const Color(0xFF1E1E1E),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white70),
            bodySmall: TextStyle(color: Colors.white60),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Color(0xFF139113)),
              foregroundColor: WidgetStatePropertyAll(Colors.white),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
          ),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF139113),
            secondary: Color(0xFF1E1E1E),
          ),
        ),

        initialRoute: Routes.splash,
        getPages: AppPages.pages,
      ),
    );
  }
}
