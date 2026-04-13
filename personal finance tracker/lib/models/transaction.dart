class Transaction {
  final int? id;
  final String type;
  final double amount;
  final String category;
  final String description;
  final DateTime date;
  final String paymentMethod;
  final bool isRecurring;
  final String? recurringType;
  final DateTime createdAt;

  Transaction({
    this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    required this.paymentMethod,
    required this.isRecurring,
    this.recurringType,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'category': category,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'paymentMethod': paymentMethod,
      'isRecurring': isRecurring ? 1 : 0,
      'recurringType': recurringType,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      type: map['type'],
      amount: map['amount'],
      category: map['category'],
      description: map['description'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      paymentMethod: map['paymentMethod'],
      isRecurring: map['isRecurring'] == 1,
      recurringType: map['recurringType'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }
}
