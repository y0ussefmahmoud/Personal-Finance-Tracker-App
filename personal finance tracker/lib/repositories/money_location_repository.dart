import '../models/money_location.dart';
import '../database/database_helper.dart';

/// Repository for managing money location data
class MoneyLocationRepository {
  final DatabaseHelper _databaseHelper;

  MoneyLocationRepository(this._databaseHelper);

  Future<List<MoneyLocation>> getAllMoneyLocations() async {
    return await _databaseHelper.getMoneyLocations();
  }

  Future<int> addMoneyLocation(MoneyLocation moneyLocation) async {
    return await _databaseHelper.insertMoneyLocation(moneyLocation);
  }

  Future<void> updateMoneyLocation(MoneyLocation moneyLocation) async {
    await _databaseHelper.updateMoneyLocation(moneyLocation);
  }

  Future<void> deleteMoneyLocation(int id) async {
    await _databaseHelper.deleteMoneyLocation(id);
  }
}
