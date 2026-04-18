/// Category Entity
/// 
/// Domain entity representing a transaction category.
library;

class CategoryEntity {
  final int? id;
  final String name;
  final int color;
  final String icon;
  final String type; // 'income', 'expense', or 'both'
  final bool isCustom;

  CategoryEntity({
    this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.type,
    required this.isCustom,
  });

  CategoryEntity copyWith({
    int? id,
    String? name,
    int? color,
    String? icon,
    String? type,
    bool? isCustom,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      isCustom: isCustom ?? this.isCustom,
    );
  }

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

  factory CategoryEntity.fromMap(Map<String, dynamic> map) {
    return CategoryEntity(
      id: map['id'] as int?,
      name: map['name'] as String,
      color: map['color'] as int,
      icon: map['icon'] as String,
      type: map['type'] as String,
      isCustom: (map['isCustom'] as int) == 1,
    );
  }

  @override
  String toString() {
    return 'CategoryEntity(id: $id, name: $name, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
