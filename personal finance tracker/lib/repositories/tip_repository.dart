import '../models/tip.dart';
import '../database/database_helper.dart';
import '../domain/repositories/tip_repository_interface.dart';
import '../domain/entities/tip_entity.dart';

/// Repository for managing tip data
/// It implements the TipRepositoryInterface from the domain layer.
class TipRepository implements TipRepositoryInterface {
  final DatabaseHelper _databaseHelper;

  TipRepository(this._databaseHelper);

  @override
  Future<List<TipEntity>> getTips() async {
    final tips = await _databaseHelper.getTips();
    return tips.map((t) => _toEntity(t)).toList();
  }

  @override
  Future<int> addTip(TipEntity entity) async {
    final tip = _toModel(entity);
    return await _databaseHelper.insertTip(tip);
  }

  @override
  Future<void> updateTip(TipEntity entity) async {
    final tip = _toModel(entity);
    await _databaseHelper.updateTip(tip);
  }

  @override
  Future<void> deleteTip(int id) async {
    await _databaseHelper.deleteTip(id);
  }

  TipEntity _toEntity(Tip model) {
    return TipEntity(
      id: model.id,
      title: model.title,
      content: model.content,
      category: model.category,
      isRead: model.isRead,
      date: model.date,
    );
  }

  Tip _toModel(TipEntity entity) {
    return Tip(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      category: entity.category,
      isRead: entity.isRead,
      date: entity.date,
    );
  }

  Future<List<Tip>> getAllTips() async {
    return await _databaseHelper.getTips();
  }

  /// Legacy method for backward compatibility - accepts Tip model
  Future<int> addTipLegacy(Tip tip) async {
    return await _databaseHelper.insertTip(tip);
  }

  /// Legacy method for backward compatibility - accepts Tip model
  Future<void> updateTipLegacy(Tip tip) async {
    await _databaseHelper.updateTip(tip);
  }
}
