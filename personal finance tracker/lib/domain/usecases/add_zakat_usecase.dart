/// Add Zakat Use Case
library;

import '../entities/zakat_entity.dart';
import '../repositories/zakat_repository_interface.dart';

class AddZakatUseCase {
  final ZakatRepositoryInterface _zakatRepository;

  AddZakatUseCase(this._zakatRepository);

  Future<int> call(ZakatEntity zakat) async {
    if (zakat.goldValue < 0) {
      throw ArgumentError('Gold value cannot be negative');
    }

    if (zakat.silverValue < 0) {
      throw ArgumentError('Silver value cannot be negative');
    }

    if (zakat.cash < 0) {
      throw ArgumentError('Cash value cannot be negative');
    }

    if (zakat.investments < 0) {
      throw ArgumentError('Investments value cannot be negative');
    }

    return await _zakatRepository.addZakat(zakat);
  }
}
