/// Add Transaction Use Case
/// 
/// This use case represents a single business logic operation:
/// adding a new transaction to the system.
/// 
/// Use Cases are the core of the business logic in Clean Architecture.
/// They orchestrate the flow of data between entities and repositories.
library;

import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository_interface.dart';

/// Use case for adding a new transaction
/// 
/// This class encapsulates the business logic for adding a transaction.
/// It validates the transaction data before passing it to the repository.
class AddTransactionUseCase {
  final TransactionRepositoryInterface _transactionRepository;

  AddTransactionUseCase(this._transactionRepository);

  /// Executes the use case to add a transaction
  /// 
  /// Returns the ID of the newly created transaction.
  /// Throws an exception if the transaction data is invalid.
  Future<int> call(TransactionEntity transaction) async {
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

    // Pass validated data to the repository
    return await _transactionRepository.addTransaction(transaction);
  }
}
