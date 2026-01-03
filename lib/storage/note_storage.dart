import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/note_model.dart';

class NoteStorage {
  static const String notesKey = 'notes';

  static Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final data = notes.map((note) => jsonEncode(note.toMap())).toList();
    await prefs.setStringList(notesKey, data);
  }

  static Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(notesKey) ?? [];
    return data.map((item) => Note.fromMap(jsonDecode(item))).toList();
  }

  static Future<void> clearNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(notesKey);
  }
}
