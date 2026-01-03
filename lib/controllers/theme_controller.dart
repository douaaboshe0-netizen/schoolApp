import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;

  ThemeMode get theme => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  void toggleTheme(bool value) async {
    isDarkMode.value = value;
    Get.changeThemeMode(theme);
    update();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedValue = prefs.getBool('isDarkMode') ?? false;
    isDarkMode.value = savedValue;
    Get.changeThemeMode(theme);
    update();
  }
}
