import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/student_controller.dart';

class OldAnnouncementsScreen extends StatelessWidget {
  const OldAnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentController>();
    final oldList = controller.oldAnnouncements;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'الإعلانات القديمة',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      body: oldList.isEmpty
          ? const Center(
              child: Text(
                'لا توجد إعلانات قديمة حالياً',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: oldList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final a = oldList[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${a.title} 📌',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 6),
                      Text('${a.description} 📝', textAlign: TextAlign.right),
                      const SizedBox(height: 6),
                      if (a.dateHijri.isNotEmpty)
                        Text('${a.dateHijri} 📅', textAlign: TextAlign.right),
                      if (a.dateMiladi.isNotEmpty)
                        Text('${a.dateMiladi} 📆', textAlign: TextAlign.right),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
