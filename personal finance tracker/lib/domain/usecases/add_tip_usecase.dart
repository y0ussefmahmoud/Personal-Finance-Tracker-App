/// Add Tip Use Case
library;

import '../entities/tip_entity.dart';
import '../repositories/tip_repository_interface.dart';

class AddTipUseCase {
  final TipRepositoryInterface _tipRepository;

  AddTipUseCase(this._tipRepository);

  Future<int> call(TipEntity tip) async {
    if (tip.title.isEmpty) {
      throw ArgumentError('Tip title cannot be empty');
    }

    if (tip.content.isEmpty) {
      throw ArgumentError('Tip content cannot be empty');
    }

    if (tip.category.isEmpty) {
      throw ArgumentError('Tip category cannot be empty');
    }

    return await _tipRepository.addTip(tip);
  }
}
