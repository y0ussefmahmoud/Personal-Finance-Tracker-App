import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' hide Category;
import '../database/database_helper.dart';
import '../models/zakat.dart';
import '../repositories/zakat_repository.dart';

class ZakatProvider extends ChangeNotifier {
  List<Zakat> zakatRecords = [];
  bool isLoading = false;
  final ZakatRepository _zakatRepository;

  ZakatProvider() : _zakatRepository = ZakatRepository(DatabaseHelper());

  double get totalPaidZakat {
    return zakatRecords.where((z) => z.paid).fold(0, (sum, z) => sum + z.totalZakat);
  }

  double get totalUnpaidZakat {
    return zakatRecords.where((z) => !z.paid).fold(0, (sum, z) => sum + z.totalZakat);
  }

  Future<void> fetchZakatRecords() async {
    isLoading = true;
    notifyListeners();
    zakatRecords = await _zakatRepository.getAllZakat();
    isLoading = false;
    notifyListeners();
  }

  Future<void> addZakatRecord(Zakat zakat) async {
    await _zakatRepository.addZakat(zakat);
    await fetchZakatRecords();
  }

  Future<void> updateZakatRecord(Zakat zakat) async {
    await _zakatRepository.updateZakat(zakat);
    await fetchZakatRecords();
  }

  Future<void> deleteZakatRecord(int id) async {
    await _zakatRepository.deleteZakat(id);
    await fetchZakatRecords();
  }
}
