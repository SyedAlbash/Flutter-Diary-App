class DiaryEntry {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final List<String> imagePaths;
  final String mood;
  final List<String> tags;
  final String backgroundColor;

  DiaryEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    this.imagePaths = const [],
    this.mood = '',
    this.tags = const [],
    this.backgroundColor = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'date': date.toIso8601String(),
        'imagePaths': imagePaths,
        'mood': mood,
        'tags': tags,
        'backgroundColor': backgroundColor,
      };

  factory DiaryEntry.fromJson(Map<String, dynamic> json) => DiaryEntry(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        date: DateTime.parse(json['date']),
        imagePaths: List<String>.from(json['imagePaths'] ?? []),
        mood: json['mood'] ?? '',
        tags: List<String>.from(json['tags'] ?? []),
        backgroundColor: json['backgroundColor'] ?? '',
      );

  DiaryEntry copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? date,
    List<String>? imagePaths,
    String? mood,
    List<String>? tags,
    String? backgroundColor,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      imagePaths: imagePaths ?? this.imagePaths,
      mood: mood ?? this.mood,
      tags: tags ?? this.tags,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}
