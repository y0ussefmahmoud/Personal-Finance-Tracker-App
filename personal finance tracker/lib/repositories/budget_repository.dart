import '../models/budget.dart';
import '../database/database_helper.dart';

/// Repository for managing budget data
class BudgetRepository {
  final DatabaseHelper _databaseHelper;

  BudgetRepository(this._databaseHelper);

  Future<List<Budget>> getAllBudgets() async {
    return await _databaseHelper.getBudgets();
  }

  Future<int> addBudget(Budget budget) async {
    return await _databaseHelper.insertBudget(budget);
  }

  Future<void> updateBudget(Budget budget) async {
    await _databaseHelper.updateBudget(budget);
  }

  Future<void> deleteBudget(int id) async {
    await _databaseHelper.deleteBudget(id);
  }
}
