class Installment {
  final int? id;
  final String name;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final DateTime dueDate;
  final double nextPayment;
  final String type; // 'installment'/'debt'
  final String status; // 'active'/'closed'

  Installment({
    this.id,
    required this.name,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.dueDate,
    required this.nextPayment,
    required this.type,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'totalAmount': totalAmount,
      'paidAmount': paidAmount,
      'remainingAmount': remainingAmount,
      'dueDate': dueDate.millisecondsSinceEpoch,
      'nextPayment': nextPayment,
      'type': type,
      'status': status,
    };
  }

  factory Installment.fromMap(Map<String, dynamic> map) {
    return Installment(
      id: map['id'],
      name: map['name'],
      totalAmount: map['totalAmount'],
      paidAmount: map['paidAmount'],
      remainingAmount: map['remainingAmount'],
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate']),
      nextPayment: map['nextPayment'],
      type: map['type'],
      status: map['status'],
    );
  }
}
