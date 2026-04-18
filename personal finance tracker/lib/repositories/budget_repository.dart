import '../models/budget.dart';
import '../database/database_helper.dart';
import '../domain/repositories/budget_repository_interface.dart';
import '../domain/entities/budget_entity.dart';

/// Repository for managing budget data
/// It implements the BudgetRepositoryInterface from the domain layer.
class BudgetRepository implements BudgetRepositoryInterface {
  final DatabaseHelper _databaseHelper;

  BudgetRepository(this._databaseHelper);

  @override
  Future<List<BudgetEntity>> getBudgets() async {
    final budgets = await _databaseHelper.getBudgets();
    return budgets.map((b) => _toEntity(b)).toList();
  }

  @override
  Future<int> addBudget(BudgetEntity entity) async {
    final budget = _toModel(entity);
    return await _databaseHelper.insertBudget(budget);
  }

  @override
  Future<void> updateBudget(BudgetEntity entity) async {
    final budget = _toModel(entity);
    await _databaseHelper.updateBudget(budget);
  }

  @override
  Future<void> deleteBudget(int id) async {
    await _databaseHelper.deleteBudget(id);
  }

  @override
  Future<List<BudgetEntity>> getBudgetsByStatus(String status) async {
    final budgets = await _databaseHelper.getBudgets();
    return budgets
        .where((b) => b.status == status)
        .map((b) => _toEntity(b))
        .toList();
  }

  BudgetEntity _toEntity(Budget model) {
    return BudgetEntity(
      id: model.id,
      category: model.category,
      amount: model.amount,
      spent: model.spent,
      startDate: model.startDate,
      endDate: model.endDate,
      status: model.status,
    );
  }

  Budget _toModel(BudgetEntity entity) {
    return Budget(
      id: entity.id,
      category: entity.category,
      amount: entity.amount,
      spent: entity.spent,
      startDate: entity.startDate,
      endDate: entity.endDate,
      status: entity.status,
    );
  }

  Future<List<Budget>> getAllBudgets() async {
    return await _databaseHelper.getBudgets();
  }

  /// Legacy method for backward compatibility - accepts Budget model
  Future<int> addBudgetLegacy(Budget budget) async {
    return await _databaseHelper.insertBudget(budget);
  }

  /// Legacy method for backward compatibility - accepts Budget model
  Future<void> updateBudgetLegacy(Budget budget) async {
    await _databaseHelper.updateBudget(budget);
  }
}
