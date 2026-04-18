import '../models/zakat.dart';
import '../database/database_helper.dart';
import '../domain/repositories/zakat_repository_interface.dart';
import '../domain/entities/zakat_entity.dart';

/// Repository for managing zakat data
/// It implements the ZakatRepositoryInterface from the domain layer.
class ZakatRepository implements ZakatRepositoryInterface {
  final DatabaseHelper _databaseHelper;

  ZakatRepository(this._databaseHelper);

  @override
  Future<List<ZakatEntity>> getZakatRecords() async {
    final zakatRecords = await _databaseHelper.getZakatRecords();
    return zakatRecords.map((z) => _toEntity(z)).toList();
  }

  @override
  Future<int> addZakat(ZakatEntity entity) async {
    final zakat = _toModel(entity);
    return await _databaseHelper.insertZakat(zakat);
  }

  @override
  Future<void> updateZakat(ZakatEntity entity) async {
    final zakat = _toModel(entity);
    await _databaseHelper.updateZakat(zakat);
  }

  @override
  Future<void> deleteZakat(int id) async {
    await _databaseHelper.deleteZakat(id);
  }

  ZakatEntity _toEntity(Zakat model) {
    return ZakatEntity(
      id: model.id,
      goldValue: model.goldValue,
      silverValue: model.silverValue,
      cash: model.cash,
      investments: model.investments,
      totalZakat: model.totalZakat,
      date: model.date,
      paid: model.paid,
    );
  }

  Zakat _toModel(ZakatEntity entity) {
    return Zakat(
      id: entity.id,
      goldValue: entity.goldValue,
      silverValue: entity.silverValue,
      cash: entity.cash,
      investments: entity.investments,
      totalZakat: entity.totalZakat,
      date: entity.date,
      paid: entity.paid,
    );
  }

  Future<List<Zakat>> getAllZakat() async {
    return await _databaseHelper.getZakatRecords();
  }

  /// Legacy method for backward compatibility - accepts Zakat model
  Future<int> addZakatLegacy(Zakat zakat) async {
    return await _databaseHelper.insertZakat(zakat);
  }

  /// Legacy method for backward compatibility - accepts Zakat model
  Future<void> updateZakatLegacy(Zakat zakat) async {
    await _databaseHelper.updateZakat(zakat);
  }
}
