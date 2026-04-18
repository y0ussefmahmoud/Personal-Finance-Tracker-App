/// Zakat Entity
library;

class ZakatEntity {
  final int? id;
  final double goldValue;
  final double silverValue;
  final double cash;
  final double investments;
  final double totalZakat;
  final DateTime date;
  final bool paid;

  ZakatEntity({
    this.id,
    required this.goldValue,
    required this.silverValue,
    required this.cash,
    required this.investments,
    required this.totalZakat,
    required this.date,
    required this.paid,
  });

  ZakatEntity copyWith({
    int? id,
    double? goldValue,
    double? silverValue,
    double? cash,
    double? investments,
    double? totalZakat,
    DateTime? date,
    bool? paid,
  }) {
    return ZakatEntity(
      id: id ?? this.id,
      goldValue: goldValue ?? this.goldValue,
      silverValue: silverValue ?? this.silverValue,
      cash: cash ?? this.cash,
      investments: investments ?? this.investments,
      totalZakat: totalZakat ?? this.totalZakat,
      date: date ?? this.date,
      paid: paid ?? this.paid,
    );
  }

  double get totalAssets => goldValue + silverValue + cash + investments;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'goldValue': goldValue,
      'silverValue': silverValue,
      'cash': cash,
      'investments': investments,
      'totalZakat': totalZakat,
      'date': date.millisecondsSinceEpoch,
      'paid': paid ? 1 : 0,
    };
  }

  factory ZakatEntity.fromMap(Map<String, dynamic> map) {
    return ZakatEntity(
      id: map['id'] as int?,
      goldValue: (map['goldValue'] as num).toDouble(),
      silverValue: (map['silverValue'] as num).toDouble(),
      cash: (map['cash'] as num).toDouble(),
      investments: (map['investments'] as num).toDouble(),
      totalZakat: (map['totalZakat'] as num).toDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      paid: (map['paid'] as int) == 1,
    );
  }

  @override
  String toString() {
    return 'ZakatEntity(id: $id, totalZakat: $totalZakat, paid: $paid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ZakatEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
