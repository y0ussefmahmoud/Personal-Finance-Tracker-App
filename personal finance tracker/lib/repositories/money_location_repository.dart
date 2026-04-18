import '../models/money_location.dart';
import '../database/database_helper.dart';
import '../domain/repositories/money_location_repository_interface.dart';
import '../domain/entities/money_location_entity.dart';

/// Repository for managing money location data
/// It implements the MoneyLocationRepositoryInterface from the domain layer.
class MoneyLocationRepository implements MoneyLocationRepositoryInterface {
  final DatabaseHelper _databaseHelper;

  MoneyLocationRepository(this._databaseHelper);

  @override
  Future<List<MoneyLocationEntity>> getMoneyLocations() async {
    final locations = await _databaseHelper.getMoneyLocations();
    return locations.map((l) => _toEntity(l)).toList();
  }

  @override
  Future<int> addMoneyLocation(MoneyLocationEntity entity) async {
    final location = _toModel(entity);
    return await _databaseHelper.insertMoneyLocation(location);
  }

  @override
  Future<void> updateMoneyLocation(MoneyLocationEntity entity) async {
    final location = _toModel(entity);
    await _databaseHelper.updateMoneyLocation(location);
  }

  @override
  Future<void> deleteMoneyLocation(int id) async {
    await _databaseHelper.deleteMoneyLocation(id);
  }

  MoneyLocationEntity _toEntity(MoneyLocation model) {
    return MoneyLocationEntity(
      id: model.id,
      name: model.name,
      actualAmount: model.actualAmount,
      icon: model.icon,
      color: model.color,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  MoneyLocation _toModel(MoneyLocationEntity entity) {
    return MoneyLocation(
      id: entity.id,
      name: entity.name,
      actualAmount: entity.actualAmount,
      icon: entity.icon,
      color: entity.color,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Future<List<MoneyLocation>> getAllMoneyLocations() async {
    return await _databaseHelper.getMoneyLocations();
  }

  /// Legacy method for backward compatibility - accepts MoneyLocation model
  Future<int> addMoneyLocationLegacy(MoneyLocation location) async {
    return await _databaseHelper.insertMoneyLocation(location);
  }

  /// Legacy method for backward compatibility - accepts MoneyLocation model
  Future<void> updateMoneyLocationLegacy(MoneyLocation location) async {
    await _databaseHelper.updateMoneyLocation(location);
  }
}
