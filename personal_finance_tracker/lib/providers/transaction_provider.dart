import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/transaction.dart' as Tx;
import '../providers/budget_provider.dart';

class TransactionProvider extends ChangeNotifier {
  List<Tx.Transaction> transactions = [];
  bool isLoading = false;
  BudgetProvider? budgetProvider;

  double get totalBalance {
    double income = 0;
    double expense = 0;
    for (final t in transactions) {
      if (t.type == 'income') {
        income += t.amount;
      } else {
        expense += t.amount;
      }
    }
    return income - expense;
  }

  double get currentMonthIncome {
    final now = DateTime.now();
    return transactions
        .where((t) => t.type == 'income' && t.date.year == now.year && t.date.month == now.month)
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
    final income = transactions
        .where((t) => t.type == 'income' && t.date.year == year)
        .fold(0.0, (sum, t) => sum + t.amount);
    final expense = transactions
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

  Map<String, double> expenseByCategoryFiltered(String filter) {
    final now = DateTime.now();
    Iterable<Tx.Transaction> filteredTransactions;
    if (filter == 'أسبوع') {
      final todayStart = DateTime(now.year, now.month, now.day);
      final weekStart = todayStart.subtract(const Duration(days: 6)); // inclusive: 7 days back
      final weekEnd = todayStart.add(const Duration(days: 1)); // exclusive end
      filteredTransactions = transactions.where((t) => t.type == 'expense' && !t.date.isBefore(weekStart) && t.date.isBefore(weekEnd));
    } else if (filter == 'سنة') {
      filteredTransactions = transactions.where((t) => t.type == 'expense' && t.date.year == now.year);
    } else {
      filteredTransactions = transactions.where((t) => t.type == 'expense' && t.date.year == now.year && t.date.month == now.month);
    }
    final map = <String, double>{};
    for (final t in filteredTransactions) {
      map[t.category] = (map[t.category] ?? 0) + t.amount;
    }
    return map;
  }

  Future<void> fetchTransactions() async {
    isLoading = true;
    notifyListeners();
    final db = DatabaseHelper();
    transactions = await db.getTransactions();
    isLoading = false;
    notifyListeners();
  }

  Future<void> addTransaction(Tx.Transaction transaction) async {
    final db = DatabaseHelper();
    await db.insertTransaction(transaction);
    await fetchTransactions();
    if (budgetProvider != null && transaction.type == 'expense') {
      final spent = expenseByCategory[transaction.category] ?? 0;
      await budgetProvider!.updateSpentForCategory(transaction.category, spent);
    }
  }

  Future<void> updateTransaction(Tx.Transaction transaction) async {
    final db = DatabaseHelper();
    final old = transactions.firstWhere((t) => t.id == transaction.id);
    await db.updateTransaction(transaction);
    await fetchTransactions();
    if (budgetProvider != null) {
      if (old.type == 'expense') {
        final spentOld = expenseByCategory[old.category] ?? 0;
        await budgetProvider!.updateSpentForCategory(old.category, spentOld);
      }
      if (transaction.type == 'expense' && transaction.category != old.category) {
        final spentNew = expenseByCategory[transaction.category] ?? 0;
        await budgetProvider!.updateSpentForCategory(transaction.category, spentNew);
      }
    }
  }

  Future<void> deleteTransaction(int id) async {
    final db = DatabaseHelper();
    final deleted = transactions.firstWhere((t) => t.id == id);
    await db.deleteTransaction(id);
    await fetchTransactions();
    if (budgetProvider != null && deleted.type == 'expense') {
      final spent = expenseByCategory[deleted.category] ?? 0;
      await budgetProvider!.updateSpentForCategory(deleted.category, spent);
    }
  }
}
