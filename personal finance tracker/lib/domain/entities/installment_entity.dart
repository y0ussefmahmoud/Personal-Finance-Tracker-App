/// Installment Entity
library;

class InstallmentEntity {
  final int? id;
  final String name;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final DateTime dueDate;
  final double nextPayment;
  final String type;
  final String status; // 'active', 'completed', 'overdue'

  InstallmentEntity({
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

  InstallmentEntity copyWith({
    int? id,
    String? name,
    double? totalAmount,
    double? paidAmount,
    double? remainingAmount,
    DateTime? dueDate,
    double? nextPayment,
    String? type,
    String? status,
  }) {
    return InstallmentEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      dueDate: dueDate ?? this.dueDate,
      nextPayment: nextPayment ?? this.nextPayment,
      type: type ?? this.type,
      status: status ?? this.status,
    );
  }

  double get progress => totalAmount > 0 ? (paidAmount / totalAmount).clamp(0.0, 1.0) : 0.0;
  bool get isCompleted => paidAmount >= totalAmount;
  bool get isOverdue => DateTime.now().isAfter(dueDate) && !isCompleted;

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

  factory InstallmentEntity.fromMap(Map<String, dynamic> map) {
    return InstallmentEntity(
      id: map['id'] as int?,
      name: map['name'] as String,
      totalAmount: (map['totalAmount'] as num).toDouble(),
      paidAmount: (map['paidAmount'] as num).toDouble(),
      remainingAmount: (map['remainingAmount'] as num).toDouble(),
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate'] as int),
      nextPayment: (map['nextPayment'] as num).toDouble(),
      type: map['type'] as String,
      status: map['status'] as String,
    );
  }

  @override
  String toString() {
    return 'InstallmentEntity(id: $id, name: $name, totalAmount: $totalAmount, paidAmount: $paidAmount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InstallmentEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
