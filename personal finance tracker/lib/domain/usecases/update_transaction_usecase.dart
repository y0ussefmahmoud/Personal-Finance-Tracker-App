/// Update Transaction Use Case
/// 
/// This use case represents a business logic operation:
/// updating an existing transaction in the system.
library;

import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository_interface.dart';

/// Use case for updating an existing transaction
/// 
/// This class encapsulates the business logic for updating a transaction.
class UpdateTransactionUseCase {
  final TransactionRepositoryInterface _transactionRepository;

  UpdateTransactionUseCase(this._transactionRepository);

  /// Executes the use case to update a transaction
  Future<void> call(TransactionEntity transaction) async {
    if (transaction.id == null) {
      throw ArgumentError('Transaction ID is required for update');
    }

    // Business logic validation
    if (transaction.amount <= 0) {
      throw ArgumentError('Transaction amount must be greater than 0');
    }

    if (transaction.category.isEmpty) {
      throw ArgumentError('Transaction category cannot be empty');
    }

    if (transaction.type != 'income' && transaction.type != 'expense') {
      throw ArgumentError('Transaction type must be either "income" or "expense"');
    }

    if (transaction.isRecurring && transaction.recurringType == null) {
      throw ArgumentError('Recurring transactions must have a recurring type');
    }

    await _transactionRepository.updateTransaction(transaction);
  }
}
