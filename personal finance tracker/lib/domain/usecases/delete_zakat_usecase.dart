/// Delete Zakat Use Case
library;

import '../repositories/zakat_repository_interface.dart';

class DeleteZakatUseCase {
  final ZakatRepositoryInterface _zakatRepository;

  DeleteZakatUseCase(this._zakatRepository);

  Future<void> call(int id) async {
    if (id <= 0) {
      throw ArgumentError('Zakat ID must be a positive integer');
    }

    await _zakatRepository.deleteZakat(id);
  }
}
