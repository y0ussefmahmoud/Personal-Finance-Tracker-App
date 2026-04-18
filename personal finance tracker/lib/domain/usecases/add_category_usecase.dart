/// Add Category Use Case
library;

import '../entities/category_entity.dart';
import '../repositories/category_repository_interface.dart';

class AddCategoryUseCase {
  final CategoryRepositoryInterface _categoryRepository;

  AddCategoryUseCase(this._categoryRepository);

  Future<int> call(CategoryEntity category) async {
    if (category.name.isEmpty) {
      throw ArgumentError('Category name cannot be empty');
    }

    if (category.type != 'income' && category.type != 'expense' && category.type != 'both') {
      throw ArgumentError('Category type must be "income", "expense", or "both"');
    }

    return await _categoryRepository.addCategory(category);
  }
}
