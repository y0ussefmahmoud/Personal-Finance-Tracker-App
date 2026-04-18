import '../models/tip.dart';
import '../database/database_helper.dart';

/// Repository for managing tip data
class TipRepository {
  final DatabaseHelper _databaseHelper;

  TipRepository(this._databaseHelper);

  Future<List<Tip>> getAllTips() async {
    return await _databaseHelper.getTips();
  }

  Future<int> addTip(Tip tip) async {
    return await _databaseHelper.insertTip(tip);
  }

  Future<void> updateTip(Tip tip) async {
    await _databaseHelper.updateTip(tip);
  }

  Future<void> deleteTip(int id) async {
    await _databaseHelper.deleteTip(id);
  }
}
