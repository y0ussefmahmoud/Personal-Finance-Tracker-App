import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' hide Category;
import '../database/database_helper.dart';
import '../models/budget.dart';
import '../repositories/budget_repository.dart';

class BudgetProvider extends ChangeNotifier {
  List<Budget> budgets = [];
  bool isLoading = false;
  final BudgetRepository _budgetRepository;

  BudgetProvider() : _budgetRepository = BudgetRepository(DatabaseHelper());

  Future<void> fetchBudgets() async {
    isLoading = true;
    notifyListeners();
    budgets = await _budgetRepository.getAllBudgets();
    isLoading = false;
    notifyListeners();
  }

  Future<void> addBudget(Budget budget) async {
    await _budgetRepository.addBudget(budget);
    await fetchBudgets();
  }

  Future<void> updateBudget(Budget budget) async {
    await _budgetRepository.updateBudget(budget);
    await fetchBudgets();
  }

  Future<void> deleteBudget(int id) async {
    await _budgetRepository.deleteBudget(id);
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
