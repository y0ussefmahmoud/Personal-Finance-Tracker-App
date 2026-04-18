/// Update Budget Use Case
library;

import '../entities/budget_entity.dart';
import '../repositories/budget_repository_interface.dart';

class UpdateBudgetUseCase {
  final BudgetRepositoryInterface _budgetRepository;

  UpdateBudgetUseCase(this._budgetRepository);

  Future<void> call(BudgetEntity budget) async {
    if (budget.id == null) {
      throw ArgumentError('Budget ID is required for update');
    }

    if (budget.amount <= 0) {
      throw ArgumentError('Budget amount must be greater than 0');
    }

    if (budget.category.isEmpty) {
      throw ArgumentError('Budget category cannot be empty');
    }

    if (budget.endDate.isBefore(budget.startDate)) {
      throw ArgumentError('End date must be after or equal to start date');
    }

    await _budgetRepository.updateBudget(budget);
  }
}
