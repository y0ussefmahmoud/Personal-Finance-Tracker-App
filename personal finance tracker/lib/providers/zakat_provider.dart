import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/zakat.dart';

class ZakatProvider extends ChangeNotifier {
  List<Zakat> zakatRecords = [];
  bool isLoading = false;

  double get totalPaidZakat {
    return zakatRecords.where((z) => z.paid).fold(0, (sum, z) => sum + z.totalZakat);
  }

  double get totalUnpaidZakat {
    return zakatRecords.where((z) => !z.paid).fold(0, (sum, z) => sum + z.totalZakat);
  }

  Future<void> fetchZakatRecords() async {
    isLoading = true;
    notifyListeners();
    final db = DatabaseHelper();
    zakatRecords = await db.getZakatRecords();
    isLoading = false;
    notifyListeners();
  }

  Future<void> addZakatRecord(Zakat zakat) async {
    final db = DatabaseHelper();
    await db.insertZakat(zakat);
    await fetchZakatRecords();
  }

  Future<void> updateZakatRecord(Zakat zakat) async {
    final db = DatabaseHelper();
    await db.updateZakat(zakat);
    await fetchZakatRecords();
  }

  Future<void> deleteZakatRecord(int id) async {
    final db = DatabaseHelper();
    await db.deleteZakat(id);
    await fetchZakatRecords();
  }
}
