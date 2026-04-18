/// Money Location Entity
library;

class MoneyLocationEntity {
  final int? id;
  final String name;
  final double actualAmount;
  final String icon;
  final int color;
  final DateTime createdAt;
  final DateTime updatedAt;

  MoneyLocationEntity({
    this.id,
    required this.name,
    required this.actualAmount,
    required this.icon,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
  });

  MoneyLocationEntity copyWith({
    int? id,
    String? name,
    double? actualAmount,
    String? icon,
    int? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MoneyLocationEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      actualAmount: actualAmount ?? this.actualAmount,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'actualAmount': actualAmount,
      'icon': icon,
      'color': color,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory MoneyLocationEntity.fromMap(Map<String, dynamic> map) {
    return MoneyLocationEntity(
      id: map['id'] as int?,
      name: map['name'] as String,
      actualAmount: (map['actualAmount'] as num).toDouble(),
      icon: map['icon'] as String,
      color: map['color'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }

  @override
  String toString() {
    return 'MoneyLocationEntity(id: $id, name: $name, actualAmount: $actualAmount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MoneyLocationEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
