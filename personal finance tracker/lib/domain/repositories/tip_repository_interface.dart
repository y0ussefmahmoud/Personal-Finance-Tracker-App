/// Tip Repository Interface
library;

import '../entities/tip_entity.dart';

abstract class TipRepositoryInterface {
  Future<List<TipEntity>> getTips();
  Future<int> addTip(TipEntity tip);
  Future<void> updateTip(TipEntity tip);
  Future<void> deleteTip(int id);
}
