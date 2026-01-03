import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final cardColor = theme.cardColor;
    final shadowColor = isDark ? Colors.black26 : Colors.black12;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.green[800],
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: const Text(
            'الإعدادات',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                GetBuilder<ThemeController>(
                  builder: (controller) => ListTile(
                    leading: Icon(
                      controller.isDarkMode.value
                          ? Icons.wb_sunny
                          : Icons.nightlight_round,
                      color: controller.isDarkMode.value
                          ? Colors.yellow
                          : Colors.grey[700],
                    ),
                    title: Text(
                      'الوضع الليلي',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    trailing: Switch(
                      value: controller.isDarkMode.value,
                      onChanged: (value) => controller.toggleTheme(value),
                      activeColor: Colors.green,
                    ),
                  ),
                ),
                Divider(color: textColor.withOpacity(0.2)),

                ListTile(
                  leading: Icon(Icons.volume_up, color: Colors.grey[700]),
                  title: Text(
                    'الصوت الافتتاحي',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {
                      //التحكم بالصوت
                    },
                    activeColor: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
