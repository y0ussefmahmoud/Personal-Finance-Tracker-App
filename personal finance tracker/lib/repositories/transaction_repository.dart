import '../models/transaction.dart';
import '../database/database_helper.dart';

/// Repository for managing transaction data
/// 
/// This class acts as an abstraction layer between the data source (DatabaseHelper)
/// and the business logic (TransactionProvider), following the Repository Pattern.
class TransactionRepository {
  final DatabaseHelper _databaseHelper;

  TransactionRepository(this._databaseHelper);

  /// Get all transactions from the database
  Future<List<Transaction>> getAllTransactions() async {
    return await _databaseHelper.getTransactions();
  }

  /// Get a single transaction by ID
  Future<Transaction?> getTransactionById(int id) async {
    final transactions = await _databaseHelper.getTransactions();
    try {
      return transactions.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Add a new transaction to the database
  Future<int> addTransaction(Transaction transaction) async {
    return await _databaseHelper.insertTransaction(transaction);
  }

  /// Update an existing transaction
  Future<void> updateTransaction(Transaction transaction) async {
    await _databaseHelper.updateTransaction(transaction);
  }

  /// Delete a transaction by ID
  Future<void> deleteTransaction(int id) async {
    await _databaseHelper.deleteTransaction(id);
  }

  /// Get transactions by type (income/expense)
  Future<List<Transaction>> getTransactionsByType(String type) async {
    final transactions = await _databaseHelper.getTransactions();
    return transactions.where((t) => t.type == type).toList();
  }

  /// Get transactions by category
  Future<List<Transaction>> getTransactionsByCategory(String category) async {
    final transactions = await _databaseHelper.getTransactions();
    return transactions.where((t) => t.category == category).toList();
  }

  /// Get transactions within a date range
  Future<List<Transaction>> getTransactionsByDateRange(DateTime start, DateTime end) async {
    final transactions = await _databaseHelper.getTransactions();
    return transactions.where((t) => 
      t.date.isAfter(start) && t.date.isBefore(end)
    ).toList();
  }
}
