/// Zakat Repository Interface
library;

import '../entities/zakat_entity.dart';

abstract class ZakatRepositoryInterface {
  Future<List<ZakatEntity>> getZakatRecords();
  Future<int> addZakat(ZakatEntity zakat);
  Future<void> updateZakat(ZakatEntity zakat);
  Future<void> deleteZakat(int id);
}
