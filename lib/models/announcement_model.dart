class AnnouncementModel {
  final String title;
  final String description;
  final String dateHijri;
  final String dateMiladi;
  final bool isNew;

  AnnouncementModel({
    required this.title,
    required this.description,
    required this.dateHijri,
    required this.dateMiladi,
    this.isNew = false,
  });
}
