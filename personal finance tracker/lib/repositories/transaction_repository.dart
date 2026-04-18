import '../models/transaction.dart';
import '../database/database_helper.dart';
import '../domain/repositories/transaction_repository_interface.dart';
import '../domain/entities/transaction_entity.dart';

/// Repository for managing transaction data
/// 
/// This class acts as an abstraction layer between the data source (DatabaseHelper)
/// and the business logic (TransactionProvider), following the Repository Pattern.
/// It implements the TransactionRepositoryInterface from the domain layer.
class TransactionRepository implements TransactionRepositoryInterface {
  final DatabaseHelper _databaseHelper;

  TransactionRepository(this._databaseHelper);

  /// Get all transactions from the database
  @override
  Future<List<TransactionEntity>> getTransactions() async {
    final transactions = await _databaseHelper.getTransactions();
    return transactions.map((t) => _toEntity(t)).toList();
  }

  /// Add a new transaction to the database
  @override
  Future<int> addTransaction(TransactionEntity entity) async {
    final transaction = _toModel(entity);
    return await _databaseHelper.insertTransaction(transaction);
  }

  /// Update an existing transaction
  @override
  Future<void> updateTransaction(TransactionEntity entity) async {
    final transaction = _toModel(entity);
    await _databaseHelper.updateTransaction(transaction);
  }

  /// Delete a transaction by ID
  @override
  Future<void> deleteTransaction(int id) async {
    await _databaseHelper.deleteTransaction(id);
  }

  /// Get transactions by type (income/expense)
  @override
  Future<List<TransactionEntity>> getTransactionsByType(String type) async {
    final transactions = await _databaseHelper.getTransactions();
    return transactions
        .where((t) => t.type == type)
        .map((t) => _toEntity(t))
        .toList();
  }

  /// Get transactions within a date range
  @override
  Future<List<TransactionEntity>> getTransactionsByDateRange(DateTime start, DateTime end) async {
    final transactions = await _databaseHelper.getTransactions();
    return transactions
        .where((t) => t.date.isAfter(start) && t.date.isBefore(end))
        .map((t) => _toEntity(t))
        .toList();
  }

  /// Convert Transaction model to TransactionEntity
  TransactionEntity _toEntity(Transaction model) {
    return TransactionEntity(
      id: model.id,
      type: model.type,
      amount: model.amount,
      category: model.category,
      description: model.description,
      date: model.date,
      paymentMethod: model.paymentMethod,
      isRecurring: model.isRecurring,
      recurringType: model.recurringType,
      createdAt: model.createdAt,
      moneyLocationId: model.moneyLocationId,
    );
  }

  /// Convert TransactionEntity to Transaction model
  Transaction _toModel(TransactionEntity entity) {
    return Transaction(
      id: entity.id,
      type: entity.type,
      amount: entity.amount,
      category: entity.category,
      description: entity.description,
      date: entity.date,
      paymentMethod: entity.paymentMethod,
      isRecurring: entity.isRecurring,
      recurringType: entity.recurringType,
      createdAt: entity.createdAt,
      moneyLocationId: entity.moneyLocationId,
    );
  }

  /// Get all transactions from the database (legacy method for backward compatibility)
  Future<List<Transaction>> getAllTransactions() async {
    return await _databaseHelper.getTransactions();
  }

  /// Get a single transaction by ID (legacy method for backward compatibility)
  Future<Transaction?> getTransactionById(int id) async {
    final transactions = await _databaseHelper.getTransactions();
    try {
      return transactions.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get transactions by category (legacy method for backward compatibility)
  Future<List<Transaction>> getTransactionsByCategory(String category) async {
    final transactions = await _databaseHelper.getTransactions();
    return transactions.where((t) => t.category == category).toList();
  }
}
