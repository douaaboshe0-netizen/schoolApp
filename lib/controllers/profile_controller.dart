import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/student_info.dart';

class ProfileController extends GetxController {
  bool isExpanded = false;
  bool isLogoutVisible = false;
  StudentInfo? student;
  Uint8List? imageBytes;

  void toggleExpanded() {
    isExpanded = !isExpanded;
    update();
  }

  void showLogoutOverlay() {
    isLogoutVisible = true;
    update();
  }

  void hideLogoutOverlay() {
    isLogoutVisible = false;
    update();
  }

  Future<void> loadStudentData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final base64 = prefs.getString('profileImageBytes');

    if (base64 != null) {
      imageBytes = Uint8List.fromList(base64.codeUnits);
    }

    final response = await http.get(
      Uri.parse("https://abdalkader.onrender.com/mobile/profile/"),
      headers: {"Authorization": "Token $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final profile = data['profile'];
      student = StudentInfo.fromJson(profile);
      update();
    } else {
      Get.snackbar("خطأ", "فشل تحميل بيانات الطالب");
    }
  }

  Future<void> updateProfileImage(Uint8List bytes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImageBytes', String.fromCharCodes(bytes));
    imageBytes = bytes;
    update();
  }

  Future<void> removeProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profileImageBytes');
    imageBytes = null;
    update();
  }
}
