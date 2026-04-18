/// Delete Transaction Use Case
/// 
/// This use case represents a business logic operation:
/// deleting a transaction from the system.
library;

import '../repositories/transaction_repository_interface.dart';

/// Use case for deleting a transaction
/// 
/// This class encapsulates the business logic for deleting a transaction.
class DeleteTransactionUseCase {
  final TransactionRepositoryInterface _transactionRepository;

  DeleteTransactionUseCase(this._transactionRepository);

  /// Executes the use case to delete a transaction
  Future<void> call(int id) async {
    if (id <= 0) {
      throw ArgumentError('Transaction ID must be a positive integer');
    }

    await _transactionRepository.deleteTransaction(id);
  }
}
