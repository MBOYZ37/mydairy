class Diary {
  int? id;
  String title;
  String content;
  String date;
  String? imagePath;

  Diary({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
      'imagePath': imagePath,
    };
  }

  factory Diary.fromMap(Map<String, dynamic> map) {
    return Diary(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: map['date'],
      imagePath: map['imagePath'],
    );
  }
}