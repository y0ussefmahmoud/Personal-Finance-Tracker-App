/// Get Zakat Records Use Case
library;

import '../entities/zakat_entity.dart';
import '../repositories/zakat_repository_interface.dart';

class GetZakatRecordsUseCase {
  final ZakatRepositoryInterface _zakatRepository;

  GetZakatRecordsUseCase(this._zakatRepository);

  Future<List<ZakatEntity>> call() async {
    return await _zakatRepository.getZakatRecords();
  }
}
