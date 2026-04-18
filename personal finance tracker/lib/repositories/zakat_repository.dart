import '../models/zakat.dart';
import '../database/database_helper.dart';

/// Repository for managing zakat data
class ZakatRepository {
  final DatabaseHelper _databaseHelper;

  ZakatRepository(this._databaseHelper);

  /// Get all zakat records from the database
  Future<List<Zakat>> getAllZakat() async {
    return await _databaseHelper.getZakatRecords();
  }

  Future<int> addZakat(Zakat zakat) async {
    return await _databaseHelper.insertZakat(zakat);
  }

  Future<void> updateZakat(Zakat zakat) async {
    await _databaseHelper.updateZakat(zakat);
  }

  Future<void> deleteZakat(int id) async {
    await _databaseHelper.deleteZakat(id);
  }
}
