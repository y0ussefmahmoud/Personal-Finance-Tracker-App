/// Tip Entity
library;

class TipEntity {
  final int? id;
  final String title;
  final String content;
  final String category;
  final bool isRead;
  final DateTime date;

  TipEntity({
    this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.isRead,
    required this.date,
  });

  TipEntity copyWith({
    int? id,
    String? title,
    String? content,
    String? category,
    bool? isRead,
    DateTime? date,
  }) {
    return TipEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      isRead: isRead ?? this.isRead,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'isRead': isRead ? 1 : 0,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory TipEntity.fromMap(Map<String, dynamic> map) {
    return TipEntity(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      category: map['category'] as String,
      isRead: (map['isRead'] as int) == 1,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  @override
  String toString() {
    return 'TipEntity(id: $id, title: $title, category: $category, isRead: $isRead)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TipEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
