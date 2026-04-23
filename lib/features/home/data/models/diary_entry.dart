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

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    String mood = json['mood'] ?? '';
    // Sanitize old paths with spaces/parentheses and fix extensions
    if (mood.contains('assets/images/emojis/') ||
        mood.contains('assets/emojis/')) {
      mood = mood
          .replaceAll('assets/images/emojis/', 'assets/emojis/')
          .replaceAll('Mood/', 'Mood_/')
          .replaceAll('Mood ', 'Mood_')
          .replaceAll(' (', '_')
          .replaceAll(')', '');

      // Fix extensions for non-Cat moods - convert to webp
      if (!mood.contains('Cat_Mood') && !mood.endsWith('.svg')) {
        mood = mood.replaceAll('.png', '.webp');
      }
    }

    String backgroundColor = json['backgroundColor'] ?? '';
    if (backgroundColor.contains('assets/images/note themes/') ||
        backgroundColor.contains('assets/note_themes/')) {
      backgroundColor = backgroundColor
          .replaceAll('assets/images/note_themes/', 'assets/note_themes/')
          .replaceAll('note themes/', 'note_themes/')
          .replaceAll(
              'abstract-dark-background-with-some-smooth-lines-it-some-spots-it 1.png',
              'abstract_dark.webp')
          .replaceAll('digital-art-style-sky-landscape-with-moon.png',
              'digital_art_sky.png')
          .replaceAll('note theme ', 'note_theme_');
    }

    return DiaryEntry(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      date: DateTime.parse(json['date']),
      imagePaths: List<String>.from(json['imagePaths'] ?? []),
      mood: mood,
      tags: List<String>.from(json['tags'] ?? []),
      backgroundColor: backgroundColor,
    );
  }

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
