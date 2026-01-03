class TaskModel {
  final String title;
  final String description;
  bool isDone;

  TaskModel({
    required this.title,
    required this.description,
    this.isDone = false,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'isDone': isDone,
  };

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    title: json['title'],
    description: json['description'],
    isDone: json['isDone'] ?? false,
  );
}
