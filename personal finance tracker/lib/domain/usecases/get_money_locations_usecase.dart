/// Get Money Locations Use Case
library;

import '../entities/money_location_entity.dart';
import '../repositories/money_location_repository_interface.dart';

class GetMoneyLocationsUseCase {
  final MoneyLocationRepositoryInterface _moneyLocationRepository;

  GetMoneyLocationsUseCase(this._moneyLocationRepository);

  Future<List<MoneyLocationEntity>> call() async {
    return await _moneyLocationRepository.getMoneyLocations();
  }
}
