/// Update Zakat Use Case
library;

import '../entities/zakat_entity.dart';
import '../repositories/zakat_repository_interface.dart';

class UpdateZakatUseCase {
  final ZakatRepositoryInterface _zakatRepository;

  UpdateZakatUseCase(this._zakatRepository);

  Future<void> call(ZakatEntity zakat) async {
    if (zakat.id == null) {
      throw ArgumentError('Zakat ID is required for update');
    }

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

    await _zakatRepository.updateZakat(zakat);
  }
}
