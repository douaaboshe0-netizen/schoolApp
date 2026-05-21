import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../routes/app_pages.dart';

class LoginResponse {
  final int id;
  final String username;
  final int studentId;
  final String name;
  final String role;

  LoginResponse({
    required this.id,
    required this.username,
    required this.studentId,
    required this.name,
    required this.role,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id'],
      username: json['username'],
      studentId: json['studentId'],
      name: json['name'],
      role: json['role'],
    );
  }
}

class LoginController extends GetxController {
  String username = '';
  String password = '';

  void setId(String value) {
    username = value.trim();
    update();
  }

  void setPassword(String value) {
    password = value.trim();
    update();
  }

  Future<void> login() async {
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar("خطأ", "يرجى إدخال البيانات كاملة");
      return;
    }

    final url = Uri.parse(
      "http://sharia-secondary-school.runasp.net/api/user/login",
    );

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        LoginResponse.fromJson(data);

        Get.snackbar(
          "",
          "",
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color.fromARGB(255, 147, 239, 107),
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(12),
          titleText: const Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
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
          backgroundColor: const Color.fromARGB(255, 239, 107, 107),
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(12),
          titleText: const Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              "اسم المستخدم أو كلمة المرور غير صحيحة",
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
      Get.snackbar("خطأ", "حدث خطأ في الاتصال بالسيرفر");
    }
  }
}
