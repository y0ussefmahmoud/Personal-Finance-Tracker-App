import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/budget.dart';

class BudgetProvider extends ChangeNotifier {
  List<Budget> budgets = [];
  bool isLoading = false;

  Future<void> fetchBudgets() async {
    isLoading = true;
    notifyListeners();
    final db = DatabaseHelper();
    budgets = await db.getBudgets();
    isLoading = false;
    notifyListeners();
  }

  Future<void> addBudget(Budget budget) async {
    final db = DatabaseHelper();
    await db.insertBudget(budget);
    await fetchBudgets();
  }

  Future<void> updateBudget(Budget budget) async {
    final db = DatabaseHelper();
    await db.updateBudget(budget);
    await fetchBudgets();
  }

  Future<void> deleteBudget(int id) async {
    final db = DatabaseHelper();
    await db.deleteBudget(id);
    await fetchBudgets();
  }

  Future<void> updateSpentForCategory(String category, double spent) async {
    final budget = budgets.where((b) => b.category == category).firstOrNull;
    if (budget != null) {
      final updated = Budget(
        id: budget.id,
        category: budget.category,
        amount: budget.amount,
        spent: spent,
        startDate: budget.startDate,
        endDate: budget.endDate,
        status: 'active',
      );
      await updateBudget(updated);
    }
  }
}
