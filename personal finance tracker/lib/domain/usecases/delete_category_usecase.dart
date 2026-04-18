/// Delete Category Use Case
library;

import '../repositories/category_repository_interface.dart';

class DeleteCategoryUseCase {
  final CategoryRepositoryInterface _categoryRepository;

  DeleteCategoryUseCase(this._categoryRepository);

  Future<void> call(int id) async {
    if (id <= 0) {
      throw ArgumentError('Category ID must be a positive integer');
    }

    await _categoryRepository.deleteCategory(id);
  }
}
