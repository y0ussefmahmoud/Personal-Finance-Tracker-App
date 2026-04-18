/// Budget Entity
library;

class BudgetEntity {
  final int? id;
  final String category;
  final double amount;
  final double spent;
  final DateTime startDate;
  final DateTime endDate;
  final String status; // 'active', 'planned', 'completed'

  BudgetEntity({
    this.id,
    required this.category,
    required this.amount,
    required this.spent,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  BudgetEntity copyWith({
    int? id,
    String? category,
    double? amount,
    double? spent,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) {
    return BudgetEntity(
      id: id ?? this.id,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      spent: spent ?? this.spent,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
    );
  }

  double get remaining => amount - spent;
  double get progress => amount > 0 ? (spent / amount).clamp(0.0, 1.0) : 0.0;
  bool get isOverBudget => spent > amount;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'spent': spent,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'status': status,
    };
  }

  factory BudgetEntity.fromMap(Map<String, dynamic> map) {
    return BudgetEntity(
      id: map['id'] as int?,
      category: map['category'] as String,
      amount: (map['amount'] as num).toDouble(),
      spent: (map['spent'] as num).toDouble(),
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int),
      status: map['status'] as String,
    );
  }

  @override
  String toString() {
    return 'BudgetEntity(id: $id, category: $category, amount: $amount, spent: $spent)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BudgetEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
