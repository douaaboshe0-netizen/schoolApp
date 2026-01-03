import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class TaskController extends GetxController {
  final List<String> days = [
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
  ];
  String selectedDay = 'الأحد';

  Map<String, List<TaskModel>> tasksByDay = {};

  @override
  void onInit() {
    super.onInit();
    _initializeTasks();
  }

  void selectDay(String day) {
    selectedDay = day;
    update();
  }

  void toggleDone(String day, int index) {
    final task = tasksByDay[day]?[index];
    if (task != null) {
      task.isDone = !task.isDone;
      _saveDoneStates(); // نحفظ فقط حالة الإنجاز
      update();
    }
  }

  // ✅ تحميل الأمثلة أول مرة فقط
  Future<void> _initializeTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('tasksByDay');

    if (raw != null) {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      tasksByDay = decoded.map((day, tasksJson) {
        final tasksList = (jsonDecode(tasksJson) as List)
            .map((e) => TaskModel.fromJson(e))
            .toList();
        return MapEntry(day, tasksList);
      });
    } else {
      // ✅ الأمثلة الجاهزة
      tasksByDay = {
        'الأحد': [
          TaskModel(title: 'رياضيات', description: 'حل تمارين صفحة 12'),
          TaskModel(title: 'علوم', description: 'قراءة درس الطاقة'),
        ],
        'الاثنين': [
          TaskModel(title: 'لغة عربية', description: 'كتابة موضوع تعبير'),
        ],
        'الثلاثاء': [
          TaskModel(title: 'إنكليزي', description: 'حفظ كلمات جديدة'),
        ],
        'الأربعاء': [
          TaskModel(title: 'دين', description: 'مراجعة سورة الفاتحة'),
        ],
        'الخميس': [
          TaskModel(title: 'اجتماعيات', description: 'قراءة درس الجغرافيا'),
        ],
      };
      await prefs.setString(
        'tasksByDay',
        jsonEncode(
          tasksByDay.map(
            (day, tasks) => MapEntry(
              day,
              jsonEncode(tasks.map((t) => t.toJson()).toList()),
            ),
          ),
        ),
      );
    }

    update();
  }

  // ✅ حفظ فقط حالة الإنجاز
  Future<void> _saveDoneStates() async {
    final prefs = await SharedPreferences.getInstance();
    final updated = tasksByDay.map((day, tasks) {
      final jsonList = tasks.map((t) => t.toJson()).toList();
      return MapEntry(day, jsonEncode(jsonList));
    });
    await prefs.setString('tasksByDay', jsonEncode(updated));
  }
}
