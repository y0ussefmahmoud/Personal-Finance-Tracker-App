/// Delete Tip Use Case
library;

import '../repositories/tip_repository_interface.dart';

class DeleteTipUseCase {
  final TipRepositoryInterface _tipRepository;

  DeleteTipUseCase(this._tipRepository);

  Future<void> call(int id) async {
    if (id <= 0) {
      throw ArgumentError('Tip ID must be a positive integer');
    }

    await _tipRepository.deleteTip(id);
  }
}
