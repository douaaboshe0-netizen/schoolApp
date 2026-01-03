import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calendar_controller.dart';

class CalendarScreen extends StatelessWidget {
  final controller = Get.put(CalendarController());
  final RxBool flipped = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        automaticallyImplyLeading: false,
        title: const Text(
          "التقويم الهجري",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx(() {
          final month = controller.currentDate.value.hMonth;
          final year = controller.currentDate.value.hYear;
          final image = controller.imageNames[month]!;
          final hadith = controller.hadiths[month]!;
          final monthName = controller.arabicMonths[month]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey.shade400, width: 0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                      onPressed: controller.previousMonth,
                    ),
                    Text(
                      "$monthName $year",
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      ),
                      onPressed: controller.nextMonth,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              GestureDetector(
                onTap: () => flipped.toggle(),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: flipped.value
                      ? Container(
                          key: const ValueKey(true),
                          height: 140,
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              hadith,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 15, height: 1.5),
                            ),
                          ),
                        )
                      : ClipRRect(
                          key: const ValueKey(false),
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            image,
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:
                      [
                            "سبت",
                            "جمعة",
                            "خميس",
                            "أربعاء",
                            "ثلاثاء",
                            "اثنين",
                            "أحد",
                          ]
                          .map(
                            (day) => Text(
                              day,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: GridView.count(
                    crossAxisCount: 7,
                    children: [
                      ...List.generate(
                        controller.offsetDays.value,
                        (_) => Container(),
                      ),
                      ...List.generate(controller.daysInMonth.value, (index) {
                        final day = index + 1;
                        final isToday = controller.isToday(day);
                        return Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isToday ? Colors.green : Colors.grey[200],
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.grey),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "$day",
                            style: TextStyle(
                              color: isToday ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: controller.goToToday,
                child: const Text("العودة لليوم الحالي"),
              ),
            ],
          );
        }),
      ),
    );
  }
}
