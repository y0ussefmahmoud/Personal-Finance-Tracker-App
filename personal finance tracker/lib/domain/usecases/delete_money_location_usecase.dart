/// Delete Money Location Use Case
library;

import '../repositories/money_location_repository_interface.dart';

class DeleteMoneyLocationUseCase {
  final MoneyLocationRepositoryInterface _moneyLocationRepository;

  DeleteMoneyLocationUseCase(this._moneyLocationRepository);

  Future<void> call(int id) async {
    if (id <= 0) {
      throw ArgumentError('Money location ID must be a positive integer');
    }

    await _moneyLocationRepository.deleteMoneyLocation(id);
  }
}
