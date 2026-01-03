import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/note_controller.dart';
import '../models/note_model.dart';

class NoteScreen extends StatelessWidget {
  const NoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final cardColor = theme.cardColor;
    final shadowColor = isDark ? Colors.black26 : Colors.black12;

    return GetBuilder<NoteController>(
      builder: (controller) {
        final filteredNotes = controller.notes.where((note) {
          final query = controller.searchText.trim().toLowerCase();
          return note.title.toLowerCase().contains(query) ||
              note.description.toLowerCase().contains(query);
        }).toList();

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.green[800],
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              title: const Text(
                'المفكرة',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ مربع البحث
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [BoxShadow(color: shadowColor, blurRadius: 4)],
                    ),
                    child: TextField(
                      onChanged: controller.updateSearchText,
                      decoration: InputDecoration(
                        icon: Icon(Icons.search, color: Colors.grey[600]),
                        hintText: 'بحث',
                        hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(color: textColor),
                    ),
                  ),

                  // ✅ عنوان القسم
                  Text(
                    'الملاحظات',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 100,
                    height: 2,
                    color: textColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 20),

                  // ✅ قائمة الملاحظات
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredNotes.length,
                      itemBuilder: (context, index) {
                        final note = filteredNotes[index];
                        final fullText = note.description.trim();
                        final words = fullText.split(RegExp(r'\s+'));
                        final previewText = words.length > 5
                            ? '${words.take(5).join(' ')}...'
                            : fullText;
                        final hasMore = words.length > 5;

                        return AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: cardColor,
                              boxShadow: [
                                BoxShadow(color: shadowColor, blurRadius: 6),
                              ],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ✅ العنوان + أدوات التعديل والحذف
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        note.title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.grey[600],
                                          ),
                                          onPressed: () {
                                            Get.toNamed(
                                              '/writeNote',
                                              arguments: {
                                                'index': controller.notes
                                                    .indexOf(note),
                                                'note': note,
                                              },
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.green,
                                          ),
                                          onPressed: () {
                                            Get.defaultDialog(
                                              title: 'حذف الملاحظة',
                                              titleStyle: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              middleText:
                                                  'هل أنت متأكد أنك تريد حذف هذه الملاحظة؟',
                                              textCancel: 'إلغاء',
                                              textConfirm: 'حذف',
                                              confirmTextColor: Colors.white,
                                              buttonColor: Colors.green,
                                              onConfirm: () {
                                                controller.deleteNote(
                                                  controller.notes.indexOf(
                                                    note,
                                                  ),
                                                );
                                                Get.back();
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                // ✅ نص الملاحظة
                                Text(
                                  note.expanded ? fullText : previewText,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: textColor.withOpacity(0.85),
                                  ),
                                ),

                                // ✅ زر عرض المزيد
                                if (hasMore)
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton.icon(
                                      onPressed: () =>
                                          controller.toggleExpanded(
                                            controller.notes.indexOf(note),
                                          ),
                                      icon: Icon(
                                        note.expanded
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                        color: Colors.green,
                                      ),
                                      label: Text(
                                        note.expanded ? 'إخفاء' : 'عرض المزيد',
                                        style: const TextStyle(
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ),

                                const SizedBox(height: 6),

                                // ✅ التاريخ
                                Text(
                                  note.date,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: textColor.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // ✅ زر إضافة ملاحظة
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green[700],
              onPressed: () => Get.toNamed('/writeNote'),
              child: const Icon(Icons.add, color: Colors.white),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
          ),
        );
      },
    );
  }
}
