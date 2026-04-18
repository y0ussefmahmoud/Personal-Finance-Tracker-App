/// Update Money Location Use Case
library;

import '../entities/money_location_entity.dart';
import '../repositories/money_location_repository_interface.dart';

class UpdateMoneyLocationUseCase {
  final MoneyLocationRepositoryInterface _moneyLocationRepository;

  UpdateMoneyLocationUseCase(this._moneyLocationRepository);

  Future<void> call(MoneyLocationEntity location) async {
    if (location.id == null) {
      throw ArgumentError('Money location ID is required for update');
    }

    if (location.name.isEmpty) {
      throw ArgumentError('Money location name cannot be empty');
    }

    if (location.actualAmount < 0) {
      throw ArgumentError('Money location amount cannot be negative');
    }

    await _moneyLocationRepository.updateMoneyLocation(location);
  }
}
