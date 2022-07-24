const String tableNotes = "notes";

class NoteFiels {
  static final List<String> values = [
    id,
    isImportant,
    number,
    title,
    description,
    time,
  ];

  static const String id = "_id";
  static const String isImportant = "isImportant";
  static const String number = "number";
  static const String title = "title";
  static const String description = "description";
  static const String time = "createdTime";
}

class Note {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  const Note({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  Note copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      Note(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );

  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFiels.id] as int?,
        isImportant: json[NoteFiels.isImportant] == 1,
        number: json[NoteFiels.number] as int,
        title: json[NoteFiels.title] as String,
        description: json[NoteFiels.description] as String,
        createdTime: DateTime.parse(json[NoteFiels.time] as String),
      );

  Map<String, Object?> toJson() => {
        NoteFiels.id: id,
        NoteFiels.isImportant: isImportant ? 1 : 0,
        NoteFiels.number: number,
        NoteFiels.title: title,
        NoteFiels.description: description,
        NoteFiels.time: createdTime.toIso8601String(),
      };
}
