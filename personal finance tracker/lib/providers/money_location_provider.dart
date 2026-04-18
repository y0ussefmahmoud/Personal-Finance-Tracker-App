import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/money_location.dart';
import '../models/transaction.dart' as transaction;

class MoneyLocationProvider extends ChangeNotifier {
  List<MoneyLocation> moneyLocations = [];
  List<transaction.Transaction> transactions = [];
  bool isLoading = false;

  Future<void> fetchMoneyLocations() async {
    isLoading = true;
    notifyListeners();
    final db = DatabaseHelper();
    moneyLocations = await db.getMoneyLocations();
    transactions = await db.getTransactions();
    isLoading = false;
    notifyListeners();
  }

  Future<void> addMoneyLocation(MoneyLocation moneyLocation) async {
    final db = DatabaseHelper();
    await db.insertMoneyLocation(moneyLocation);
    await fetchMoneyLocations();
  }

  Future<void> updateMoneyLocation(MoneyLocation moneyLocation) async {
    final db = DatabaseHelper();
    await db.updateMoneyLocation(moneyLocation);
    await fetchMoneyLocations();
  }

  Future<void> deleteMoneyLocation(int id) async {
    final db = DatabaseHelper();
    await db.deleteMoneyLocation(id);
    await fetchMoneyLocations();
  }

  double calculateExpectedAmount(int moneyLocationId) {
    final locationTransactions = transactions
        .where((t) => t.moneyLocationId == moneyLocationId)
        .toList();

    final income = locationTransactions
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);

    final expense = locationTransactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);

    return income - expense;
  }

  double get totalExpectedAmount => moneyLocations.fold(0.0, (sum, ml) => sum + calculateExpectedAmount(ml.id!));
  double get totalActualAmount => moneyLocations.fold(0.0, (sum, ml) => sum + ml.actualAmount);
  double get totalDeficit => totalActualAmount - totalExpectedAmount;
  bool get hasAnyDeficit => totalDeficit < -0.01;

  Future<void> seedDefaultMoneyLocations() async {
    final db = DatabaseHelper();
    final seeded = await db.getSetting('money_locations_seeded');
    
    debugPrint('=== MONEY LOCATIONS SEEDING ===');
    debugPrint('Seeded status: $seeded');
    
    final existingLocations = await db.getMoneyLocations();
    final existingNames = existingLocations.map((ml) => ml.name).toSet();
    
    debugPrint('Existing money locations: ${existingNames.toList()}');
    
    if (seeded != 'true') {
      debugPrint('Seeding default money locations...');
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
      
      debugPrint('Inserting ${defaultLocations.length} money locations...');
      for (final ml in defaultLocations) {
        await db.insertMoneyLocation(ml);
        debugPrint('Inserted money location: ${ml.name}');
      }
      
      await db.setSetting('money_locations_seeded', 'true');
      debugPrint('Money locations seeding completed!');
      await fetchMoneyLocations();
    } else {
      debugPrint('Money locations already seeded');
      await fetchMoneyLocations();
    }
  }
}
