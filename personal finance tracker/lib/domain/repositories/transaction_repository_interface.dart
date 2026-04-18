/// Transaction Repository Interface
/// 
/// This interface defines the contract for transaction data operations.
/// It follows the Dependency Inversion Principle from Clean Architecture.
/// The domain layer depends on this abstraction, not on the implementation.
library;

import '../entities/transaction_entity.dart';

/// Abstract repository interface for transaction operations
/// 
/// This interface defines all possible operations that can be performed
/// on transactions without specifying how they are implemented.
/// The actual implementation will be in the data layer (lib/repositories/).
abstract class TransactionRepositoryInterface {
  /// Retrieves all transactions from the data source
  Future<List<TransactionEntity>> getTransactions();

  /// Adds a new transaction to the data source
  /// 
  /// Returns the ID of the newly created transaction
  Future<int> addTransaction(TransactionEntity transaction);

  /// Updates an existing transaction in the data source
  Future<void> updateTransaction(TransactionEntity transaction);

  /// Deletes a transaction from the data source by its ID
  Future<void> deleteTransaction(int id);

  /// Retrieves transactions filtered by type (income/expense)
  Future<List<TransactionEntity>> getTransactionsByType(String type);

  /// Retrieves transactions within a date range
  Future<List<TransactionEntity>> getTransactionsByDateRange(DateTime start, DateTime end);
}
