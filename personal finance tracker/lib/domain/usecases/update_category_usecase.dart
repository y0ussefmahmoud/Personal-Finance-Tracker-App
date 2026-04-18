/// Update Category Use Case
library;

import '../entities/category_entity.dart';
import '../repositories/category_repository_interface.dart';

class UpdateCategoryUseCase {
  final CategoryRepositoryInterface _categoryRepository;

  UpdateCategoryUseCase(this._categoryRepository);

  Future<void> call(CategoryEntity category) async {
    if (category.id == null) {
      throw ArgumentError('Category ID is required for update');
    }

    if (category.name.isEmpty) {
      throw ArgumentError('Category name cannot be empty');
    }

    if (category.type != 'income' && category.type != 'expense' && category.type != 'both') {
      throw ArgumentError('Category type must be "income", "expense", or "both"');
    }

    await _categoryRepository.updateCategory(category);
  }
}
