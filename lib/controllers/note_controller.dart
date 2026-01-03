import 'package:get/get.dart';
import '../models/note_model.dart';
import '../storage/note_storage.dart';

class NoteController extends GetxController {
  List<Note> notes = [];
  String searchText = '';

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  void addNote({
    required String title,
    required String description,
    required String date,
  }) {
    notes.add(Note(title: title, description: description, date: date));
    NoteStorage.saveNotes(notes);
    update();
  }

  void updateNote(int index, String title, String description, String date) {
    notes[index] = Note(
      title: title,
      description: description,
      date: date,
      expanded: notes[index].expanded,
    );
    NoteStorage.saveNotes(notes);
    update();
  }

  void deleteNote(int index) {
    notes.removeAt(index);
    NoteStorage.saveNotes(notes);
    update();
  }

  void toggleExpanded(int index) {
    notes[index].expanded = !notes[index].expanded;
    update();
  }

  void updateSearchText(String value) {
    searchText = value;
    update();
  }

  Future<void> loadNotes() async {
    notes = await NoteStorage.loadNotes();
    update();
  }
}
