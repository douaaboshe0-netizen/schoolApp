class Note {
  final String title;
  final String description;
  final String date;
  bool expanded;

  Note({
    required this.title,
    required this.description,
    required this.date,
    this.expanded = false,
  });

  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
    'date': date,
    'expanded': expanded,
  };

  factory Note.fromMap(Map<String, dynamic> map) => Note(
    title: map['title'] ?? '',
    description: map['description'] ?? '',
    date: map['date'] ?? '',
    expanded: map['expanded'] ?? false,
  );
}
