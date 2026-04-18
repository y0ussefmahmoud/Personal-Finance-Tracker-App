/// Get Budgets Use Case
library;

import '../entities/budget_entity.dart';
import '../repositories/budget_repository_interface.dart';

class GetBudgetsUseCase {
  final BudgetRepositoryInterface _budgetRepository;

  GetBudgetsUseCase(this._budgetRepository);

  Future<List<BudgetEntity>> call() async {
    return await _budgetRepository.getBudgets();
  }
}
