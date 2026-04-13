class Tip {
  final int? id;
  final String title;
  final String content;
  final String category; // 'saving'/'investment'/'budgeting'
  final bool isRead;
  final DateTime date;

  Tip({
    this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.isRead,
    required this.date,
  });

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

  factory Tip.fromMap(Map<String, dynamic> map) {
    return Tip(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      category: map['category'],
      isRead: map['isRead'] == 1,
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }
}
