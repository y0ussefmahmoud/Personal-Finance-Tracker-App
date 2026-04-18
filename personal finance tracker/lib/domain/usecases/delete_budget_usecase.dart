/// Delete Budget Use Case
library;

import '../repositories/budget_repository_interface.dart';

class DeleteBudgetUseCase {
  final BudgetRepositoryInterface _budgetRepository;

  DeleteBudgetUseCase(this._budgetRepository);

  Future<void> call(int id) async {
    if (id <= 0) {
      throw ArgumentError('Budget ID must be a positive integer');
    }

    await _budgetRepository.deleteBudget(id);
  }
}
