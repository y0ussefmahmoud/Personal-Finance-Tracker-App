import 'package:flutter/foundation.dart' hide Category;
import '../database/database_helper.dart';
import '../models/money_location.dart';
import '../models/transaction.dart' as transaction;
import '../repositories/money_location_repository.dart';

class MoneyLocationProvider extends ChangeNotifier {
  List<MoneyLocation> moneyLocations = [];
  List<transaction.Transaction> transactions = [];
  bool isLoading = false;
  final MoneyLocationRepository _moneyLocationRepository;

  MoneyLocationProvider()
      : _moneyLocationRepository = MoneyLocationRepository(DatabaseHelper());

  Future<void> fetchMoneyLocations() async {
    isLoading = true;
    notifyListeners();
    final db = DatabaseHelper();
    moneyLocations = await _moneyLocationRepository.getAllMoneyLocations();
    transactions = await db.getTransactions();
    isLoading = false;
    notifyListeners();
  }

  Future<void> addMoneyLocation(MoneyLocation moneyLocation) async {
    await _moneyLocationRepository.addMoneyLocationLegacy(moneyLocation);
    await fetchMoneyLocations();
  }

  Future<void> updateMoneyLocation(MoneyLocation moneyLocation) async {
    await _moneyLocationRepository.updateMoneyLocationLegacy(moneyLocation);
    await fetchMoneyLocations();
  }

  Future<void> deleteMoneyLocation(int id) async {
    await _moneyLocationRepository.deleteMoneyLocation(id);
    await fetchMoneyLocations();
  }

  double calculateExpectedAmount(int moneyLocationId) {
    return moneyLocations.firstWhere((ml) => ml.id == moneyLocationId).actualAmount;
  }

  double get totalExpectedAmount => moneyLocations.fold(0.0, (sum, ml) => sum + ml.actualAmount);
  double get totalActualAmount => moneyLocations.fold(0.0, (sum, ml) => sum + ml.actualAmount);
  double get totalDeficit => totalExpectedAmount - totalActualAmount;
  bool get hasAnyDeficit => totalDeficit > 0.01;

  Future<void> seedDefaultMoneyLocations() async {
    final db = DatabaseHelper();
    final seeded = await db.getSetting('money_locations_seeded');
    
    if (kDebugMode) {
      debugPrint('=== MONEY LOCATIONS SEEDING ===');
      debugPrint('Seeded status: $seeded');
    }
    
    final existingLocations = await db.getMoneyLocations();
    final existingNames = existingLocations.map((ml) => ml.name).toSet();
    
    if (kDebugMode) debugPrint('Existing money locations: ${existingNames.toList()}');
    
    if (seeded != 'true') {
      if (kDebugMode) debugPrint('Seeding default money locations...');
      final defaultLocations = [
        MoneyLocation(
          name: 'كاش',
          actualAmount: 0,
          icon: 'account_balance_wallet',
          color: 0xFF4CAF50,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        MoneyLocation(
          name: 'بنك',
          actualAmount: 0,
          icon: 'account_balance',
          color: 0xFF2196F3,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        MoneyLocation(
          name: 'محفظة إلكترونية',
          actualAmount: 0,
          icon: 'smartphone',
          color: 0xFFFF9800,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
      
      if (kDebugMode) debugPrint('Inserting ${defaultLocations.length} money locations...');
      for (final ml in defaultLocations) {
        await db.insertMoneyLocation(ml);
        if (kDebugMode) debugPrint('Inserted money location: ${ml.name}');
      }
      
      await db.setSetting('money_locations_seeded', 'true');
      if (kDebugMode) debugPrint('Money locations seeding completed!');
      await fetchMoneyLocations();
    } else {
      if (kDebugMode) debugPrint('Money locations already seeded');
      await fetchMoneyLocations();
    }
  }
}
