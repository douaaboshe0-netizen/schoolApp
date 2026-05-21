import 'package:get/get.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../models/student_info.dart';

class ProfileController extends GetxController {
  bool isExpanded = false;
  bool isLogoutVisible = false;

  StudentInfo? student;
  Uint8List? imageBytes;

  int? studentId;

  @override
  void onInit() {
    studentId = Get.arguments;
    loadStudentData();
    super.onInit();
  }

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
    final url = Uri.parse(
      "http://sharia-secondary-school.runasp.net/api/student/$studentId",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      student = StudentInfo.fromJson(data);
    } else {
      print("خطأ في جلب بيانات الطالب");
    }

    update();
  }

  void updateProfileImage(Uint8List bytes) {
    imageBytes = bytes;
    update();
  }

  void removeProfileImage() {
    imageBytes = null;
    update();
  }
}
