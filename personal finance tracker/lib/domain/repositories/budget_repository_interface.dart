/// Budget Repository Interface
library;

import '../entities/budget_entity.dart';

abstract class BudgetRepositoryInterface {
  Future<List<BudgetEntity>> getBudgets();
  Future<int> addBudget(BudgetEntity budget);
  Future<void> updateBudget(BudgetEntity budget);
  Future<void> deleteBudget(int id);
  Future<List<BudgetEntity>> getBudgetsByStatus(String status);
}
