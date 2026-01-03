import 'package:get/get.dart';

import '../views/splash_screen.dart';
import '../views/login_screen.dart';
import '../views/student_screen.dart';
import '../views/old_announcements_screen.dart';
import '../views/note_screen.dart';
import '../views/write_note_screen.dart';
import '../views/task_screen.dart';
import '../views/setting_screen.dart';
import '../views/record_screen.dart';
import '../views/week_schedule_screen.dart';
import '../views/calendar_screen.dart';

import '../bindings/splash_binding.dart';
import '../bindings/login_binding.dart';
import '../bindings/student_binding.dart';
import '../bindings/note_binding.dart';
import '../bindings/task_binding.dart';
import '../bindings/record_binding.dart';
import '../bindings/calendar_binding.dart';

import '../middlewares/auth_middleware.dart';

class Routes {
  static const splash = '/splash';
  static const login = '/login';
  static const student = '/student';
  static const old = '/oldAnnouncements';
  static const note = '/notePage';
  static const writeNote = '/writeNote';
  static const tasks = '/tasks';
  static const settings = '/settingsPage';
  static const studentRecord = '/studentRecord';
  static const weekPage = '/weekPage';
  static const calendarPage = '/calendarPage';
}

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.student,
      page: () => const StudentScreen(),
      binding: StudentBinding(),
    ),
    GetPage(name: Routes.old, page: () => const OldAnnouncementsScreen()),
    GetPage(
      name: Routes.note,
      page: () => NoteScreen(),
      binding: NoteBinding(),
    ),
    GetPage(name: Routes.writeNote, page: () => WriteNoteScreen()),
    GetPage(
      name: Routes.tasks,
      page: () => const TaskScreen(),
      binding: TaskBinding(),
    ),
    GetPage(name: Routes.settings, page: () => SettingScreen()),
    GetPage(
      name: Routes.studentRecord,
      page: () => RecordScreen(),
      binding: RecordBinding(),
    ),
    GetPage(name: Routes.weekPage, page: () => const WeekScheduleScreen()),
    GetPage(
      name: Routes.calendarPage,
      page: () => CalendarScreen(),
      // binding: CalendarBinding(),
    ),
  ];
}
