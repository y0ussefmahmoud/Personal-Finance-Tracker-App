class Zakat {
  final int? id;
  final double goldValue;
  final double silverValue;
  final double cash;
  final double investments;
  final double totalZakat;
  final DateTime date;
  final bool paid;

  Zakat({
    this.id,
    required this.goldValue,
    required this.silverValue,
    required this.cash,
    required this.investments,
    required this.totalZakat,
    required this.date,
    required this.paid,
  });

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

  factory Zakat.fromMap(Map<String, dynamic> map) {
    return Zakat(
      id: map['id'],
      goldValue: map['goldValue'],
      silverValue: map['silverValue'],
      cash: map['cash'],
      investments: map['investments'],
      totalZakat: map['totalZakat'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      paid: map['paid'] == 1,
    );
  }
}
