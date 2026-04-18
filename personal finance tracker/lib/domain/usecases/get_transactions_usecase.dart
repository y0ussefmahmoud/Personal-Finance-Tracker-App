/// Get Transactions Use Case
/// 
/// This use case represents a business logic operation:
/// retrieving all transactions from the system.
library;

import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository_interface.dart';

/// Use case for retrieving all transactions
/// 
/// This class encapsulates the business logic for retrieving transactions.
class GetTransactionsUseCase {
  final TransactionRepositoryInterface _transactionRepository;

  GetTransactionsUseCase(this._transactionRepository);

  /// Executes the use case to get all transactions
  Future<List<TransactionEntity>> call() async {
    return await _transactionRepository.getTransactions();
  }
}
