/// Add Budget Use Case
library;

import '../entities/budget_entity.dart';
import '../repositories/budget_repository_interface.dart';

class AddBudgetUseCase {
  final BudgetRepositoryInterface _budgetRepository;

  AddBudgetUseCase(this._budgetRepository);

  Future<int> call(BudgetEntity budget) async {
    if (budget.amount <= 0) {
      throw ArgumentError('Budget amount must be greater than 0');
    }

    if (budget.category.isEmpty) {
      throw ArgumentError('Budget category cannot be empty');
    }

    if (budget.endDate.isBefore(budget.startDate)) {
      throw ArgumentError('End date must be after or equal to start date');
    }

    return await _budgetRepository.addBudget(budget);
  }
}
