/// Get Tips Use Case
library;

import '../entities/tip_entity.dart';
import '../repositories/tip_repository_interface.dart';

class GetTipsUseCase {
  final TipRepositoryInterface _tipRepository;

  GetTipsUseCase(this._tipRepository);

  Future<List<TipEntity>> call() async {
    return await _tipRepository.getTips();
  }
}
