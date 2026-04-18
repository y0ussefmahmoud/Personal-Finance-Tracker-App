/// Add Money Location Use Case
library;

import '../entities/money_location_entity.dart';
import '../repositories/money_location_repository_interface.dart';

class AddMoneyLocationUseCase {
  final MoneyLocationRepositoryInterface _moneyLocationRepository;

  AddMoneyLocationUseCase(this._moneyLocationRepository);

  Future<int> call(MoneyLocationEntity location) async {
    if (location.name.isEmpty) {
      throw ArgumentError('Money location name cannot be empty');
    }

    if (location.actualAmount < 0) {
      throw ArgumentError('Money location amount cannot be negative');
    }

    return await _moneyLocationRepository.addMoneyLocation(location);
  }
}
