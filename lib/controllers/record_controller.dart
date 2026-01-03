import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RecordController extends GetxController {
  String studentName = 'محمد الأحمد';
  String studentClass = 'الصف الثاني الثانوي | الشعبة الثانية';

  List<String> notes = [
    'الطالب يشارك بانتظام في الحصص.',
    'يحتاج إلى تحسين في مادة الرياضيات.',
    'يتفاعل بشكل جيد مع زملائه.',
  ];

  
  Map<String, int> grades = {};

  int absenceCount = 3;
  String selectedSection = '';

  void toggleSection(String section) {
    selectedSection = selectedSection == section ? '' : section;
    update();
  }

  int get totalScore =>
      grades.isEmpty ? 0 : grades.values.reduce((a, b) => a + b);

  int get maxScore => grades.length * 100;

  double get percentageFromTotal {
    if (maxScore == 0) return 0;
    return (totalScore / maxScore) * 100;
  }

  
  Future<void> fetchMarks() async {
    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getInt('userId'); 

    if (studentId == null) return;

    final url = Uri.parse(
      "http://abdalkadrbadran.runasp.net/api/student/marks/$studentId",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        
        grades = data.map<String, int>((key, value) {
          return MapEntry(key.toString(), int.parse(value.toString()));
        });

        update();
      } else {
        print("فشل في جلب العلامات: ${response.statusCode}");
      }
    } catch (e) {
      print("خطأ في الاتصال بالسيرفر: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchMarks(); 
  }
}
