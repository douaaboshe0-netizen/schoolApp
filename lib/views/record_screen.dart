import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/record_controller.dart';
import 'progress_circle_painter.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final cardColor = theme.cardColor;
    final shadowColor = isDark ? Colors.black26 : Colors.grey.shade300;

    return GetBuilder<RecordController>(
      init: RecordController(),
      builder: (controller) {
        final percentage = controller.percentageFromTotal;
        final percentageColor = getColorForPercentage(percentage, context);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.green[700],
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text(
              'سجل الطالب',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          body: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                height: 160,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: shadowColor, blurRadius: 6)],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'الاسم: ${controller.studentName}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            controller.studentClass,
                            style: TextStyle(color: textColor.withOpacity(0.6)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.green, width: 2),
                        image: const DecorationImage(
                          image: AssetImage('images/profile.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomPaint(
                      painter: ProgressCirclePainter(percentage, context),
                      child: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cardColor,
                        ),
                        child: Text(
                          '${percentage.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: percentageColor,
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      'أدائي',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    buildStaticBox(
                      context,
                      'الغياب',
                      'images/fulse.jpg',
                      controller.absenceCount,
                    ),
                    const SizedBox(width: 8),
                    buildExpandableBox(
                      context,
                      'العلامات',
                      'images/mark.jpg',
                      'grades',
                      controller,
                    ),
                    const SizedBox(width: 8),
                    buildExpandableBox(
                      context,
                      'الملاحظات',
                      'images/note2.jpg',
                      'notes',
                      controller,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (controller.selectedSection.isNotEmpty)
                Container(
                  width: double.infinity,
                  height: 250,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: shadowColor, blurRadius: 6)],
                  ),
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      child: buildSectionContent(context, controller),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget buildStaticBox(
    BuildContext context,
    String title,
    String imagePath,
    int count,
  ) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final shadowColor = theme.brightness == Brightness.dark
        ? Colors.black26
        : Colors.grey.shade300;

    return Expanded(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: shadowColor, blurRadius: 4)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 30,
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
            Text(
              'عدد الأيام: $count',
              style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildExpandableBox(
    BuildContext context,
    String title,
    String imagePath,
    String key,
    RecordController controller,
  ) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final isSelected = controller.selectedSection == key;
    final shadowColor = theme.brightness == Brightness.dark
        ? Colors.black26
        : Colors.grey.shade300;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.toggleSection(key),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: isSelected ? Colors.green[50] : cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: shadowColor, blurRadius: 4)],
            border: Border.all(
              color: isSelected ? Colors.green : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 30,
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
              Icon(
                isSelected
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionContent(
    BuildContext context,
    RecordController controller,
  ) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    switch (controller.selectedSection) {
      case 'notes':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: controller.notes
              .map(
                (note) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    note,
                    textAlign: TextAlign.right,
                    style: TextStyle(color: textColor),
                  ),
                ),
              )
              .toList(),
        );

      case 'grades':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ...controller.grades.entries.map((entry) {
              final isFail = entry.value < 50;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  '${entry.key}: ${entry.value}/100',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: isFail ? Colors.red : textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),
            const Divider(height: 24, thickness: 1),
            Text(
              'المجموع العام: ${controller.totalScore}/${controller.maxScore}',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        );

      default:
        return const SizedBox();
    }
  }

  Color getColorForPercentage(double percentage, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (percentage < 50) return isDark ? Colors.red.shade300 : Colors.red;
    if (percentage < 75) return isDark ? Colors.orange.shade300 : Colors.orange;
    return isDark ? Colors.green.shade400 : Colors.green.shade800;
  }
}
