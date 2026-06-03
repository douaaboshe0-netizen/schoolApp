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
    super.onInit();

    // استلام رقم الطالب من صفحة تسجيل الدخول
    studentId = Get.arguments;

    print("📌 studentId المستلم: $studentId");

    if (studentId == null) {
      print("❌ لم يتم استلام studentId");
      return;
    }

    loadStudentData();
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

    print("🔍 طلب البيانات من: $url");

    try {
      final response = await http.get(url);

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        student = StudentInfo.fromJson(data);
        print("✅ تم تحميل بيانات الطالب بنجاح");
      } else {
        print("❌ خطأ في جلب بيانات الطالب");
      }
    } catch (e) {
      print("⚠️ خطأ أثناء الاتصال بالسيرفر: $e");
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
