import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/transaction.dart' as transaction;
import '../providers/budget_provider.dart';

/// Transaction Provider - Manages all financial transactions
/// 
/// This provider handles:
/// - CRUD operations for transactions
/// - Financial calculations (balance, income, expenses)
/// - Category-wise expense tracking
/// - Budget integration and updates
/// - Monthly and yearly statistics
/// 
/// Usage:
/// ```dart
/// final provider = context.read<TransactionProvider>();
/// await provider.addTransaction(transaction);
/// final balance = provider.totalBalance;
/// ```

class TransactionProvider extends ChangeNotifier {
  // Private fields
  List<transaction.Transaction> _transactions = [];
  bool _isLoading = false;
  BudgetProvider? budgetProvider;

  // Public getters
  /// List of all transactions
  List<transaction.Transaction> get transactions => List.unmodifiable(_transactions);
  
  /// Loading state indicator
  bool get isLoading => _isLoading;

  // Financial Calculations
  
  /// Calculates total balance (income - expenses)
  double get totalBalance {
    double income = 0;
    double expense = 0;
    
    for (final t in _transactions) {
      if (t.type == 'income') {
        income += t.amount;
      } else {
        expense += t.amount;
      }
    }
    
    return income - expense;
  }

  /// Calculates current month's total income
  double get currentMonthIncome {
    final now = DateTime.now();
    return _transactions
        .where((t) => t.type == 'income' && 
                    t.date.year == now.year && 
                    t.date.month == now.month)
        .fold(0, (sum, t) => sum + t.amount);
  }

  double get currentMonthExpense {
    final now = DateTime.now();
    return transactions
        .where((t) => t.type == 'expense' && t.date.year == now.year && t.date.month == now.month)
        .fold(0, (sum, t) => sum + t.amount);
  }

  Map<String, double> get expenseByCategory {
    final map = <String, double>{};
    for (final t in transactions.where((t) => t.type == 'expense')) {
      map[t.category] = (map[t.category] ?? 0) + t.amount;
    }
    return map;
  }

  List<Map<String, dynamic>> getMonthlyData(int monthsBack) {
    final now = DateTime.now();
    final data = <Map<String, dynamic>>[];
    for (int i = monthsBack - 1; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      final income = transactions
          .where((t) => t.type == 'income' && t.date.year == date.year && t.date.month == date.month)
          .fold(0.0, (sum, t) => sum + t.amount);
      final expense = transactions
          .where((t) => t.type == 'expense' && t.date.year == date.year && t.date.month == date.month)
          .fold(0.0, (sum, t) => sum + t.amount);
      final savings = income - expense;
      final label = DateFormat('MMMM', 'ar_EG').format(date);
      data.add({
        'label': label,
        'income': income,
        'expense': expense,
        'savings': savings,
      });
    }
    return data;
  }

  List<Map<String, dynamic>> getWeeklyData() {
    final now = DateTime.now();
    final data = <Map<String, dynamic>>[];
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final income = transactions
          .where((t) => t.type == 'income' && t.date.year == date.year && t.date.month == date.month && t.date.day == date.day)
          .fold(0.0, (sum, t) => sum + t.amount);
      final expense = transactions
          .where((t) => t.type == 'expense' && t.date.year == date.year && t.date.month == date.month && t.date.day == date.day)
          .fold(0.0, (sum, t) => sum + t.amount);
      final savings = income - expense;
      final label = DateFormat('EEEE', 'ar_EG').format(date);
      data.add({
        'label': label,
        'income': income,
        'expense': expense,
        'savings': savings,
      });
    }
    return data;
  }

  List<Map<String, dynamic>> getYearlyData() {
    final now = DateTime.now();
    final data = <Map<String, dynamic>>[];
    final year = now.year;
    final income = _transactions
        .where((t) => t.type == 'income' && t.date.year == year)
        .fold(0.0, (sum, t) => sum + t.amount);
    final expense = _transactions
        .where((t) => t.type == 'expense' && t.date.year == year)
        .fold(0.0, (sum, t) => sum + t.amount);
    final savings = income - expense;
    final label = 'السنة الحالية';
    data.add({
      'label': label,
      'income': income,
      'expense': expense,
      'savings': savings,
    });
    return data;
  }

  // CRUD Operations
  
  /// Fetches all transactions from database
  /// 
  /// Sets loading state during fetch and notifies listeners
  Future<void> fetchTransactions() async {
    _setLoading(true);
    
    try {
      final db = DatabaseHelper();
      _transactions = await db.getTransactions();
    } catch (e) {
      // TODO: Add error handling
      debugPrint('Error fetching transactions: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Adds a new transaction to database
  /// 
  /// [transaction] The transaction to add
  /// Updates budget if it's an expense transaction
  Future<void> addTransaction(transaction.Transaction transaction) async {
    try {
      final db = DatabaseHelper();
      await db.insertTransaction(transaction);
      
      // Refresh data
      await fetchTransactions();
      
      // Update budget if expense
      if (budgetProvider != null && transaction.type == 'expense') {
        final spent = expenseByCategory[transaction.category] ?? 0;
        await budgetProvider!.updateSpentForCategory(transaction.category, spent);
      }
    } catch (e) {
      debugPrint('Error adding transaction: $e');
      rethrow;
    }
  }

  /// Updates an existing transaction
  /// 
  /// [transaction] The transaction with updated data
  /// Handles budget updates for category changes
  Future<void> updateTransaction(transaction.Transaction transaction) async {
    try {
      final db = DatabaseHelper();
      final old = _transactions.firstWhere((t) => t.id == transaction.id);
      
      await db.updateTransaction(transaction);
      await fetchTransactions();
      
      // Update budgets if needed
      await _handleBudgetUpdates(old, transaction);
    } catch (e) {
      debugPrint('Error updating transaction: $e');
      rethrow;
    }
  }

  /// Deletes a transaction by ID
  /// 
  /// [id] The ID of the transaction to delete
  /// Updates budget if it's an expense transaction
  Future<void> deleteTransaction(int id) async {
    try {
      final db = DatabaseHelper();
      final deleted = _transactions.firstWhere((t) => t.id == id);
      
      await db.deleteTransaction(id);
      await fetchTransactions();
      
      // Update budget if expense
      if (budgetProvider != null && deleted.type == 'expense') {
        final spent = expenseByCategory[deleted.category] ?? 0;
        await budgetProvider!.updateSpentForCategory(deleted.category, spent);
      }
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
      rethrow;
    }
  }

  // Private Helper Methods
  
  /// Sets loading state and notifies listeners
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  /// Handles budget updates when transaction is modified
  Future<void> _handleBudgetUpdates(
    transaction.Transaction old, 
    transaction.Transaction newTransaction
  ) async {
    if (budgetProvider == null) return;
    
    // Update old category if it was expense
    if (old.type == 'expense') {
      final spentOld = expenseByCategory[old.category] ?? 0;
      await budgetProvider!.updateSpentForCategory(old.category, spentOld);
    }
    
    // Update new category if it's expense and different
    if (newTransaction.type == 'expense' && newTransaction.category != old.category) {
      final spentNew = expenseByCategory[newTransaction.category] ?? 0;
      await budgetProvider!.updateSpentForCategory(newTransaction.category, spentNew);
    }
  }
}
