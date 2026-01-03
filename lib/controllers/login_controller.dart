import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../routes/app_pages.dart';

class LoginController extends GetxController {
  String id = '';
  String password = '';
  bool isLoading = false;

  void setId(String value) {
    id = value;
    update(); 
  }

  void setPassword(String value) {
    password = value;
    update(); 
  }

  void login() async {
    if (id.isEmpty || password.isEmpty) {
      Get.snackbar("خطأ", "يرجى إدخال البيانات كاملة");
      return;
    }

    isLoading = true;
    update(); 

    final prefs = await SharedPreferences.getInstance();
    final url = Uri.parse("http://abdalkadrbadran.runasp.net/api/auth/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": int.parse(id.trim()),
          "password": password.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        await prefs.setBool('isLoggedIn', true);
        await prefs.setInt('userId', data["userId"]);
        await prefs.setString('username', data["username"]);
        await prefs.setString('role', data["role"]);

        Get.snackbar(
          "",
          "",
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color.fromARGB(255, 147, 239, 107),
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(12),
          titleText: Directionality(
            textDirection: TextDirection.rtl,
            child: const Text(
              "تم تسجيل الدخول بنجاح",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        );

        Get.offNamed(Routes.student);
      } else {
        Get.snackbar(
          "",
          "",
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color.fromARGB(255, 147, 239, 107),
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(12),
          titleText: Directionality(
            textDirection: TextDirection.rtl,
            child: const Text(
              "فشل تسجيل الدخول. تأكد من الرقم وكلمة المرور.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      Get.snackbar(
        "",
        "",
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color.fromARGB(255, 147, 239, 107),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(12),
        titleText: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            "خطأ بالاتصال بالسيرفر: $e",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    isLoading = false;
    update(); 
  }
}
