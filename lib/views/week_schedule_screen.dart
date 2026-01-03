import 'package:flutter/material.dart';

class WeekScheduleScreen extends StatelessWidget {
  const WeekScheduleScreen({super.key});

  final List<String> days = const [
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
  ];

  final List<String> periods = const [
    'الحصة 1',
    'الحصة 2',
    'الحصة 3',
    'الحصة 4',
    'الحصة 5',
    'الحصة 6',
    'الحصة 7',
  ];

  final Map<String, List<String>> schedule = const {
    'الأحد': [
      'توحيد',
      'كيمياء',
      'لغة عربية',
      'فيزياء',
      'قرآن',
      'نشاط',
      'رياضة',
    ],
    'الاثنين': [
      'حديث',
      'رياضيات',
      'علوم',
      'تفسير',
      'لغة إنجليزية',
      'حاسوب',
      'فقه',
    ],
    'الثلاثاء': ['فقه', 'حاسوب', 'كيمياء', 'توحيد', 'رياضة', 'قرآن', 'علوم'],
    'الأربعاء': [
      'قرآن',
      'فيزياء',
      'لغة عربية',
      'علوم',
      'تفسير',
      'نشاط',
      'رياضيات',
    ],
    'الخميس': [
      'حديث',
      'رياضيات',
      'لغة إنجليزية',
      'فقه',
      'نشاط',
      'كيمياء',
      'توحيد',
    ],
  };

  Color getSubjectColor(String subject, bool isDark) {
    final isShar3i = [
      'تفسير',
      'حديث',
      'فقه',
      'توحيد',
      'قرآن',
    ].contains(subject);
    return isShar3i
        ? Colors.green
        : isDark
        ? Colors.brown[200]!
        : const Color(0xFF6B4F2C);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.green[800],
          title: const Text(
            'برنامج الأسبوع',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                '﴿ وَقُلْ رَبِّ زِدْنِي عِلْمًا ﴾',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: 'Amiri',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Container(width: 220, height: 2, color: textColor),
              const SizedBox(height: 24),
              Table(
                border: TableBorder.all(color: textColor.withOpacity(0.2)),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {0: FixedColumnWidth(90)},
                children: [
                  TableRow(
                    children: [
                      Container(
                        height: 60,
                        color: Colors.green,
                        child: Stack(
                          children: [
                            CustomPaint(
                              size: const Size(
                                double.infinity,
                                double.infinity,
                              ),
                              painter: DiagonalLinePainter(),
                            ),
                            const Positioned(
                              top: 4,
                              left: 6,
                              child: Text(
                                'اليوم',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const Positioned(
                              bottom: 4,
                              right: 6,
                              child: Text(
                                'الحصص',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...days.map(
                        (day) => Container(
                          color: Colors.green,
                          height: 60,
                          child: Center(
                            child: Text(
                              day,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  for (int i = 0; i < periods.length; i++)
                    TableRow(
                      children: [
                        Container(
                          color: cardColor,
                          height: 60,
                          child: Center(
                            child: Text(
                              periods[i],
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        ...days.map((day) {
                          final subject = schedule[day]?[i] ?? '';
                          return Container(
                            height: 60,
                            color: cardColor,
                            child: Center(
                              child: Text(
                                subject,
                                style: TextStyle(
                                  color: getSubjectColor(subject, isDark),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DiagonalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5;

    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
