/// Transaction Entity
/// 
/// Domain entity representing a financial transaction.
/// This is a pure domain model with no dependencies on external frameworks or data sources.
/// It follows the principles of Clean Architecture by being independent of the data layer.
library;

/// Represents a financial transaction in the domain layer
/// 
/// This entity contains only the business logic and properties needed
/// for a transaction, without any database-specific details.
class TransactionEntity {
  final int? id;
  final String type; // 'income' or 'expense'
  final double amount;
  final String category;
  final String description;
  final DateTime date;
  final String paymentMethod;
  final bool isRecurring;
  final String? recurringType; // 'daily', 'weekly', 'monthly', 'yearly'
  final DateTime createdAt;
  final int? moneyLocationId;

  TransactionEntity({
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
    this.moneyLocationId,
  });

  /// Creates a copy of this transaction with the given fields replaced
  TransactionEntity copyWith({
    int? id,
    String? type,
    double? amount,
    String? category,
    String? description,
    DateTime? date,
    String? paymentMethod,
    bool? isRecurring,
    String? recurringType,
    DateTime? createdAt,
    int? moneyLocationId,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringType: recurringType ?? this.recurringType,
      createdAt: createdAt ?? this.createdAt,
      moneyLocationId: moneyLocationId ?? this.moneyLocationId,
    );
  }

  /// Converts the entity to a map (useful for serialization)
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
      'moneyLocationId': moneyLocationId,
    };
  }

  /// Creates an entity from a map (useful for deserialization)
  factory TransactionEntity.fromMap(Map<String, dynamic> map) {
    return TransactionEntity(
      id: map['id'] as int?,
      type: map['type'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      description: map['description'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      paymentMethod: map['paymentMethod'] as String,
      isRecurring: (map['isRecurring'] as int) == 1,
      recurringType: map['recurringType'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      moneyLocationId: map['moneyLocationId'] as int?,
    );
  }

  @override
  String toString() {
    return 'TransactionEntity(id: $id, type: $type, amount: $amount, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TransactionEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
