import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/theme_controller.dart';
import 'routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 19, 150, 19),
            iconTheme: IconThemeData(color: Colors.white),
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

        darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF1B1B1B),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2C2C2C),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          cardColor: const Color(0xFF2E2E2E),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.grey),
            bodyMedium: TextStyle(color: Colors.grey),
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF2C2C2C),
            brightness: Brightness.dark,
          ),
        ),

        initialRoute: Routes.splash,
        getPages: AppPages.pages,
      ),
    );
  }
}
