/// Update Tip Use Case
library;

import '../entities/tip_entity.dart';
import '../repositories/tip_repository_interface.dart';

class UpdateTipUseCase {
  final TipRepositoryInterface _tipRepository;

  UpdateTipUseCase(this._tipRepository);

  Future<void> call(TipEntity tip) async {
    if (tip.id == null) {
      throw ArgumentError('Tip ID is required for update');
    }

    if (tip.title.isEmpty) {
      throw ArgumentError('Tip title cannot be empty');
    }

    if (tip.content.isEmpty) {
      throw ArgumentError('Tip content cannot be empty');
    }

    if (tip.category.isEmpty) {
      throw ArgumentError('Tip category cannot be empty');
    }

    await _tipRepository.updateTip(tip);
  }
}
