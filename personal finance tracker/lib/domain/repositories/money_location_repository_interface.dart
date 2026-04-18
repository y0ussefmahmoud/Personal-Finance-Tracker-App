/// Money Location Repository Interface
library;

import '../entities/money_location_entity.dart';

abstract class MoneyLocationRepositoryInterface {
  Future<List<MoneyLocationEntity>> getMoneyLocations();
  Future<int> addMoneyLocation(MoneyLocationEntity location);
  Future<void> updateMoneyLocation(MoneyLocationEntity location);
  Future<void> deleteMoneyLocation(int id);
}
