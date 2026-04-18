class MoneyLocation {
  final int? id;
  final String name;
  final double actualAmount;
  final String icon;
  final int color;
  final DateTime createdAt;
  final DateTime updatedAt;

  MoneyLocation({
    this.id,
    required this.name,
    required this.actualAmount,
    required this.icon,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
  });

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

  factory MoneyLocation.fromMap(Map<String, dynamic> map) {
    return MoneyLocation(
      id: map['id'],
      name: map['name'],
      actualAmount: map['actualAmount'] ?? 0.0,
      icon: map['icon'],
      color: map['color'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  MoneyLocation copyWith({
    int? id,
    String? name,
    double? actualAmount,
    String? icon,
    int? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MoneyLocation(
      id: id ?? this.id,
      name: name ?? this.name,
      actualAmount: actualAmount ?? this.actualAmount,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
