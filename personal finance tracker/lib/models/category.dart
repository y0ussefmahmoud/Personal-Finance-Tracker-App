class Category {
  final int? id;
  final String name;
  final int color;
  final String icon;
  final String type;
  final bool isCustom;

  Category({
    this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.type,
    required this.isCustom,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'icon': icon,
      'type': type,
      'isCustom': isCustom ? 1 : 0,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      color: map['color'],
      icon: map['icon'],
      type: map['type'],
      isCustom: map['isCustom'] == 1,
    );
  }
}
