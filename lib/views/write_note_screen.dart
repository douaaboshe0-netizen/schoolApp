import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/note_controller.dart';
import '../models/note_model.dart';

class WriteNoteScreen extends StatefulWidget {
  const WriteNoteScreen({super.key});

  @override
  State<WriteNoteScreen> createState() => _WriteNoteScreenState();
}

class _WriteNoteScreenState extends State<WriteNoteScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  int? editingIndex;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null && args['note'] != null) {
      final Note note = args['note'];
      editingIndex = args['index'];
      titleController.text = note.title;
      descriptionController.text = note.description;
    }
  }

  void handleBack() {
    final hasText =
        titleController.text.trim().isNotEmpty ||
        descriptionController.text.trim().isNotEmpty;
    if (hasText) {
      Get.defaultDialog(
        title: 'تأكيد',
        titleStyle: const TextStyle(fontWeight: FontWeight.bold),
        middleText: 'هل تريد التراجع عن الكتابة؟',
        textCancel: 'لا',
        textConfirm: 'نعم',
        confirmTextColor: Colors.white,
        buttonColor: Colors.green,
        onConfirm: () => Get.back(closeOverlays: true),
      );
    } else {
      Get.back();
    }
  }

  void handleSave(NoteController controller) {
    final title = titleController.text.trim();
    final desc = descriptionController.text.trim();
    final date = 'اليوم ${DateTime.now().day} أكتوبر 2025';

    if (title.isNotEmpty || desc.isNotEmpty) {
      if (editingIndex != null) {
        controller.updateNote(editingIndex!, title, desc, date);
      } else {
        controller.addNote(title: title, description: desc, date: date);
      }
      Get.back();
    } else {
      Get.defaultDialog(
        title: 'تنبيه',
        titleStyle: const TextStyle(fontWeight: FontWeight.bold),
        middleText: 'لا يمكن حفظ ملاحظة فارغة',
        textConfirm: 'موافق',
        confirmTextColor: Colors.white,
        buttonColor: Colors.green,
        onConfirm: () => Get.back(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NoteController>();
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final cardColor = theme.cardColor;
    final hintStyle = TextStyle(color: textColor.withOpacity(0.5));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.green[800],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: handleBack,
          ),
          title: const Text(
            'كتابة ملاحظة',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              onPressed: () => handleSave(controller),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'العنوان',
                  hintStyle: hintStyle,
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Divider(thickness: 1, color: textColor.withOpacity(0.2)),
              Expanded(
                child: TextField(
                  controller: descriptionController,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'اكتب ملاحظتك هنا...',
                    hintStyle: hintStyle,
                    border: InputBorder.none,
                  ),
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
